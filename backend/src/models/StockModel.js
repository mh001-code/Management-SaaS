// backend/src/models/StockModel.js
import pool from "../config/db.js";

// Se estiver dentro de transação, usaremos um client específico
let clientTransaction = null;

// Chamar isso em controllers que iniciam transação:
// StockModel.setTransactionClient(client)
export const setTransactionClient = (client) => {
  clientTransaction = client;
};

// Executor controlado — usa client da transação se existir, senão pool normal
const q = async (text, params) => {
  if (clientTransaction) {
    return clientTransaction.query(text, params);
  }
  return pool.query(text, params);
};

// Obter estoque atual (com lock para evitar race conditions quando dentro de transação)
export const getCurrentStock = async (product_id) => {
  const result = await q(
    `SELECT COALESCE(quantity, 0) AS stock_quantity
     FROM stock
     WHERE product_id = $1
     FOR UPDATE`,
    [product_id]
  );

  return Number(result.rows[0]?.stock_quantity || 0);
};

// Atualizar estoque com valor absoluto
export const updateStock = async (product_id, quantity) => {
  const result = await q(
    `UPDATE stock
     SET quantity = $1, last_updated = NOW()
     WHERE product_id = $2
     RETURNING *`,
    [quantity, product_id]
  );

  return result.rows[0];
};

// Decrementar estoque (ajuste relativo)
export const decrementStock = async (productId, quantity) => {
  const executor = clientTransaction || pool;

  const res = await executor.query(
    `UPDATE stock
     SET quantity = quantity - $1, last_updated = NOW()
     WHERE product_id = $2 AND quantity >= $1
     RETURNING quantity`,
    [quantity, productId]
  );

  if (!res.rowCount) {
    throw new Error(`⚠️ Estoque insuficiente para o produto ${productId}`);
  }

  return res.rows[0].quantity;
};

// Restaura estoque (usado ao editar pedido para devolver o que estava reservado antes)
export const restoreStock = async (productId, quantity) => {
  const executor = clientTransaction || pool;

  const res = await executor.query(
    `UPDATE stock
     SET quantity = quantity + $1, last_updated = NOW()
     WHERE product_id = $2
     RETURNING *`,
    [quantity, productId]
  );

  console.log("🔄 Estoque restaurado:", res.rows[0]);
  return res.rows[0];
};

// Obter estoque com bloqueio (para uso em transações de atualização de pedidos)
export const getCurrentStockForUpdate = async (productId) => {
  const executor = clientTransaction || pool;

  const res = await executor.query(
    `SELECT quantity
     FROM stock
     WHERE product_id = $1
     FOR UPDATE`,
    [productId]
  );

  return res.rows[0]?.quantity ?? 0;
};

// Incrementar estoque (quando remover item do pedido)
export const incrementStock = async (productId, quantity) => {
  const result = await q(
    `UPDATE stock
     SET quantity = quantity + $1, last_updated = NOW()
     WHERE product_id = $2
     RETURNING *`,
    [quantity, productId]
  );

  console.log("➕ Estoque incrementado:", result.rows[0]);
  return result.rows[0];
};

// Criar registro inicial de estoque para novo produto
export const addStock = async (product_id, quantity = 0) => {
  const result = await q(
    `INSERT INTO stock (product_id, quantity)
     VALUES ($1, $2)
     RETURNING *`,
    [product_id, quantity]
  );

  return result.rows[0];
};

// Inserir ou atualizar estoque (para novos produtos criados ou atualizados)
export const upsertStock = async (product_id, quantity) => {
  const existing = await q(
    `SELECT * FROM stock WHERE product_id = $1`,
    [product_id]
  );

  if (existing.rows.length > 0) {
    const updated = await q(
      `UPDATE stock
       SET quantity = $1, last_updated = NOW()
       WHERE product_id = $2
       RETURNING *`,
      [quantity, product_id]
    );
    return updated.rows[0];
  } else {
    const inserted = await q(
      `INSERT INTO stock (product_id, quantity)
       VALUES ($1, $2)
       RETURNING *`,
      [product_id, quantity]
    );
    return inserted.rows[0];
  }
};