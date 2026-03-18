import pool from "../config/db.js";

export const getAllSuppliers = async () => {
  const res = await pool.query(
    `SELECT id, name, email, phone, document, contact_name, notes, created_at
     FROM suppliers
     ORDER BY name`
  );
  return res.rows;
};

export const getSupplierById = async (id) => {
  const res = await pool.query(
    `SELECT id, name, email, phone, document, contact_name, notes, created_at
     FROM suppliers WHERE id = $1`,
    [id]
  );
  return res.rows[0];
};

export const createSupplier = async (data) => {
  const { name, email, phone, document, contact_name, notes } = data;
  const res = await pool.query(
    `INSERT INTO suppliers (name, email, phone, document, contact_name, notes)
     VALUES ($1, $2, $3, $4, $5, $6)
     RETURNING *`,
    [name, email || null, phone || null, document || null, contact_name || null, notes || null]
  );
  return res.rows[0];
};

export const updateSupplier = async (id, data) => {
  const { name, email, phone, document, contact_name, notes } = data;
  const res = await pool.query(
    `UPDATE suppliers
     SET name         = COALESCE($1, name),
         email        = COALESCE($2, email),
         phone        = COALESCE($3, phone),
         document     = COALESCE($4, document),
         contact_name = COALESCE($5, contact_name),
         notes        = COALESCE($6, notes)
     WHERE id = $7
     RETURNING *`,
    [name, email, phone, document, contact_name, notes, id]
  );
  return res.rows[0];
};

export const deleteSupplier = async (id) => {
  const res = await pool.query(
    `DELETE FROM suppliers WHERE id = $1 RETURNING id`,
    [id]
  );
  return res.rows[0];
};
