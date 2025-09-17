// backend/src/models/OrderItemModel.js
import pool from "../config/db.js";

export const createOrderItem = async (orderId, productId, quantity, price) => {
  const result = await pool.query(
    `INSERT INTO order_items (order_id, product_id, quantity, price)
     VALUES ($1, $2, $3, $4)
     RETURNING *`,
    [orderId, productId, quantity, price]
  );
  return result.rows[0];
};

export const getItemsByOrderId = async (orderId) => {
  const result = await pool.query(
    `SELECT oi.id, oi.product_id, p.name as product_name, oi.quantity, oi.price
     FROM order_items oi
     JOIN products p ON oi.product_id = p.id
     WHERE oi.order_id = $1`,
    [orderId]
  );
  return result.rows;
};
