// backend/src/models/StockModel.js
import pool from "../config/db.js";

// Listar estoque de todos produtos
export const getAllStock = async () => {
  const result = await pool.query(
    `SELECT s.id, s.product_id, p.name as product_name, s.quantity, s.last_updated
     FROM stock s
     JOIN products p ON s.product_id = p.id
     ORDER BY s.id`
  );
  return result.rows;
};

// Atualizar estoque de um produto (entrada ou ajuste manual)
export const updateStock = async (product_id, quantity) => {
  const result = await pool.query(
    `UPDATE stock
     SET quantity=$1, last_updated=NOW()
     WHERE product_id=$2
     RETURNING *`,
    [quantity, product_id]
  );
  return result.rows[0]; // undefined se não encontrar
};

// Adicionar novo produto ao estoque
export const addStock = async (product_id, quantity) => {
  const result = await pool.query(
    `INSERT INTO stock (product_id, quantity) VALUES ($1, $2) RETURNING *`,
    [product_id, quantity]
  );
  return result.rows[0];
};
