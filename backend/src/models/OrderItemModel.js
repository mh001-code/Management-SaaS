import pool from "../config/db.js";

// ✅ Todas as funções recebem um executor opcional (client de transação ou pool)
// Isso elimina o estado global e resolve a race condition

const getExecutor = (client) => client || pool;

export const getItemsByOrderId = async (orderId, client) => {
  const executor = getExecutor(client);
  const res = await executor.query(
    `SELECT product_id, quantity, price
     FROM order_items
     WHERE order_id = $1
     FOR UPDATE`,
    [orderId]
  );
  return res.rows;
};

export const deleteItemsByOrderId = async (orderId, client) => {
  const executor = getExecutor(client);
  await executor.query(
    `DELETE FROM order_items WHERE order_id = $1`,
    [orderId]
  );
};

export const createOrderItem = async (orderId, productId, quantity, price, client) => {
  const executor = getExecutor(client);
  const res = await executor.query(
    `INSERT INTO order_items (order_id, product_id, quantity, price)
     VALUES ($1, $2, $3, $4)
     RETURNING *`,
    [orderId, productId, quantity, price]
  );
  return res.rows[0];
};