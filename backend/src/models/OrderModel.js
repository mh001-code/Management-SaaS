// backend/src/models/OrderModel.js
import pool from "../config/db.js";

export const getAllOrders = async () => {
  const result = await pool.query(
    "SELECT id, client_id, user_id, total, status, created_at FROM orders"
  );
  return result.rows;
};

export const getOrderById = async (id) => {
  const result = await pool.query(
    "SELECT id, client_id, user_id, total, status, created_at FROM orders WHERE id=$1",
    [id]
  );
  return result.rows[0];
};

export const createOrder = async (clientId, userId, total, status = "Pendente") => {
  const result = await pool.query(
    "INSERT INTO orders (client_id, user_id, total, status) VALUES ($1, $2, $3, $4) RETURNING id, client_id, user_id, total, status, created_at",
    [clientId, userId, total, status]
  );
  return result.rows[0];
};

export const updateOrderStatus = async (id, status) => {
  const result = await pool.query(
    `UPDATE orders
     SET status = $1
     WHERE id=$2
     RETURNING id, client_id, user_id, total, status, created_at`,
    [status, id]
  );
  return result.rows[0];
};

export const deleteOrder = async (id) => {
  const result = await pool.query("DELETE FROM orders WHERE id=$1 RETURNING id", [id]);
  return result.rows[0];
};
