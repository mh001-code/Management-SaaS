import pool from "../config/db.js";

// Obter estoque atual
export const getCurrentStock = async (product_id) => {
  const result = await pool.query(
    `SELECT COALESCE(quantity, 0) AS stock_quantity
     FROM stock
     WHERE product_id = $1`,
    [product_id]
  );
  return result.rows[0]?.stock_quantity || 0;
};

// Atualizar estoque (entrada ou saída)
export const updateStock = async (product_id, quantity) => {
  const result = await pool.query(
    `UPDATE stock
     SET quantity = $1, last_updated = NOW()
     WHERE product_id = $2
     RETURNING *`,
    [quantity, product_id]
  );
  return result.rows[0];
};

export const decrementStock = async (productId, quantity) => {
  const res = await pool.query(
    `UPDATE stock
     SET quantity = quantity - $1, last_updated = NOW()
     WHERE product_id = $2 AND quantity >= $1
     RETURNING *`,
    [quantity, productId]
  );
  console.log("🔻 Estoque decrementado:", res.rows[0]);
  return res.rows[0];
};

// Criar registro de estoque para novo produto
export const addStock = async (product_id, quantity = 0) => {
  const result = await pool.query(
    `INSERT INTO stock (product_id, quantity) VALUES ($1, $2) RETURNING *`,
    [product_id, quantity]
  );
  return result.rows[0];
};

// backend/src/models/StockModel.js
export const upsertStock = async (product_id, quantity) => {
  const existing = await pool.query(
    `SELECT * FROM stock WHERE product_id = $1`,
    [product_id]
  );

  if (existing.rows.length > 0) {
    const updated = await pool.query(
      `UPDATE stock
       SET quantity = $1, last_updated = NOW()
       WHERE product_id = $2
       RETURNING *`,
      [quantity, product_id]
    );
    return updated.rows[0];
  } else {
    const inserted = await pool.query(
      `INSERT INTO stock (product_id, quantity) VALUES ($1, $2) RETURNING *`,
      [product_id, quantity]
    );
    return inserted.rows[0];
  }
};
