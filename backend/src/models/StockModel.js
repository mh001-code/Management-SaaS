import pool from "../config/db.js";

// ✅ Todas as funções recebem um executor opcional (client de transação ou pool)
// Isso elimina o estado global e resolve a race condition

const getExecutor = (client) => client || pool;

export const getCurrentStock = async (productId, client) => {
  const executor = getExecutor(client);
  const res = await executor.query(
    `SELECT COALESCE(quantity, 0) AS stock_quantity
     FROM stock
     WHERE product_id = $1
     FOR UPDATE`,
    [productId]
  );
  return Number(res.rows[0]?.stock_quantity || 0);
};

export const getCurrentStockForUpdate = async (productId, client) => {
  const executor = getExecutor(client);
  const res = await executor.query(
    `SELECT quantity FROM stock WHERE product_id = $1 FOR UPDATE`,
    [productId]
  );
  return res.rows[0]?.quantity ?? 0;
};

export const updateStock = async (productId, quantity, client) => {
  const executor = getExecutor(client);
  const res = await executor.query(
    `UPDATE stock
     SET quantity = $1, last_updated = NOW()
     WHERE product_id = $2
     RETURNING *`,
    [quantity, productId]
  );
  return res.rows[0];
};

export const decrementStock = async (productId, quantity, client) => {
  const executor = getExecutor(client);
  const res = await executor.query(
    `UPDATE stock
     SET quantity = quantity - $1, last_updated = NOW()
     WHERE product_id = $2 AND quantity >= $1
     RETURNING quantity`,
    [quantity, productId]
  );
  if (!res.rowCount) {
    throw new Error(`Estoque insuficiente para o produto ${productId}`);
  }
  return res.rows[0].quantity;
};

export const restoreStock = async (productId, quantity, client) => {
  const executor = getExecutor(client);
  const res = await executor.query(
    `UPDATE stock
     SET quantity = quantity + $1, last_updated = NOW()
     WHERE product_id = $2
     RETURNING *`,
    [quantity, productId]
  );
  return res.rows[0];
};

export const incrementStock = async (productId, quantity, client) => {
  const executor = getExecutor(client);
  const res = await executor.query(
    `UPDATE stock
     SET quantity = quantity + $1, last_updated = NOW()
     WHERE product_id = $2
     RETURNING *`,
    [quantity, productId]
  );
  return res.rows[0];
};

export const addStock = async (productId, quantity = 0, client) => {
  const executor = getExecutor(client);
  const res = await executor.query(
    `INSERT INTO stock (product_id, quantity) VALUES ($1, $2) RETURNING *`,
    [productId, quantity]
  );
  return res.rows[0];
};

export const upsertStock = async (productId, quantity, client) => {
  const executor = getExecutor(client);
  const res = await executor.query(
    `INSERT INTO stock (product_id, quantity)
     VALUES ($1, $2)
     ON CONFLICT (product_id)
     DO UPDATE SET quantity = $2, last_updated = NOW()
     RETURNING *`,
    [productId, quantity]
  );
  return res.rows[0];
};

// ─── Movimento de estoque (stockController) ───────────────────────────────────
export const addStockMovement = async ({ product_id, quantity, type, reference_id }) => {
  const res = await pool.query(
    `INSERT INTO stock_movements (product_id, quantity, type, reference_id)
     VALUES ($1, $2, $3, $4)
     RETURNING *`,
    [product_id, quantity, type, reference_id]
  );
  return res.rows[0];
};