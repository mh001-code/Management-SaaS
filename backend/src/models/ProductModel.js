// backend/src/models/ProductModel.js
import pool from "../config/db.js";

// Listar todos os produtos com estoque correto
export const getAllProducts = async () => {
  const result = await pool.query(`
    SELECT p.id, p.name, p.description, p.price, COALESCE(s.quantity, 0) AS stock, p.created_at
    FROM products p
    LEFT JOIN stock s ON s.product_id = p.id
    ORDER BY p.id
  `);
  return result.rows;
};

// Buscar produto por ID com estoque correto
export const getProductById = async (id) => {
  const result = await pool.query(`
    SELECT p.id, p.name, p.description, p.price, COALESCE(s.quantity, 0) AS stock, p.created_at
    FROM products p
    LEFT JOIN stock s ON s.product_id = p.id
    WHERE p.id = $1
  `, [id]);
  return result.rows[0]; // undefined se não encontrar
};

// Criar novo produto
export const createProduct = async ({ name, description, price }) => {
  const result = await pool.query(
    "INSERT INTO products (name, description, price) VALUES ($1, $2, $3) RETURNING *",
    [name, description || "", price]
  );
  return result.rows[0];
};

// Atualizar produto
export const updateProduct = async (id, { name, description, price }) => {
  const result = await pool.query(
    `UPDATE products
     SET name = COALESCE($1, name),
         description = COALESCE($2, description),
         price = COALESCE($3, price)
     WHERE id = $4
     RETURNING *`,
    [name, description, price, id]
  );
  return result.rows[0]; // undefined se não encontrar
};

// Deletar produto
export const deleteProduct = async (id) => {
  const result = await pool.query("DELETE FROM products WHERE id = $1 RETURNING id", [id]);
  return result.rows[0]; // undefined se não encontrar
};
