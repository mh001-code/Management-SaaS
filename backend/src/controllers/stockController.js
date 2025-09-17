import pool from "../config/db.js";

// Listar estoque de todos produtos
export const getStock = async (req, res, next) => {
  try {
    const result = await pool.query(
      "SELECT s.id, s.product_id, p.name as product_name, s.quantity, s.last_updated " +
      "FROM stock s JOIN products p ON s.product_id = p.id ORDER BY s.id"
    );
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
};

// Atualizar estoque de um produto (entrada ou ajuste manual)
export const updateStock = async (req, res, next) => {
  try {
    const { product_id, quantity } = req.body;

    if (!product_id || quantity === undefined) {
      return res.status(400).json({ error: "product_id e quantity são obrigatórios" });
    }

    const result = await pool.query(
      "UPDATE stock SET quantity=$1, last_updated=NOW() WHERE product_id=$2 RETURNING *",
      [quantity, product_id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Produto não encontrado no estoque" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
};

// Adicionar novo produto ao estoque
export const addStock = async (req, res, next) => {
  try {
    const { product_id, quantity } = req.body;

    if (!product_id || quantity === undefined) {
      return res.status(400).json({ error: "product_id e quantity são obrigatórios" });
    }

    const result = await pool.query(
      "INSERT INTO stock (product_id, quantity) VALUES ($1, $2) RETURNING *",
      [product_id, quantity]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    next(err);
  }
};
