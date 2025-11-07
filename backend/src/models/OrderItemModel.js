// backend/src/models/OrderItemModel.js
import pool from "../config/db.js";

// Client de transação compartilhado
let transactionClient = null;

export const setTransactionClient = (client) => {
  transactionClient = client;
};

// Wrapper inteligente que usa transação se existir
const q = async (text, params) => {
  if (transactionClient) {
    return transactionClient.query(text, params);
  }
  return pool.query(text, params);
};

// Buscar itens de um pedido (com FOR UPDATE caso esteja em transação)
export const getItemsByOrderId = async (order_id) => {
  const res = await q(
    `SELECT product_id, quantity, price
     FROM order_items
     WHERE order_id = $1
     FOR UPDATE`, // trava itens enquanto pedido é modificado
    [order_id]
  );
  return res.rows;
};

// Remover todos itens do pedido
export const deleteItemsByOrderId = async (order_id) => {
  await q(
    `DELETE FROM order_items
     WHERE order_id = $1`,
    [order_id]
  );
};

// Criar item do pedido
export const createOrderItem = async (order_id, product_id, quantity, price) => {
  const res = await q(
    `INSERT INTO order_items (order_id, product_id, quantity, price)
     VALUES ($1, $2, $3, $4)
     RETURNING *`,
    [order_id, product_id, quantity, price]
  );
  return res.rows[0];
};
