import pool from "../config/db.js";

export const getAllClients = async () => {
  const result = await pool.query(
    "SELECT id, name, email, phone, address, created_at FROM clients ORDER BY name"
  );
  return result.rows;
};

export const getClientById = async (id) => {
  const result = await pool.query(
    "SELECT id, name, email, phone, address, created_at FROM clients WHERE id=$1",
    [id]
  );
  return result.rows[0];
};

export const createClient = async (name, email, phone, address) => {
  const result = await pool.query(
    `INSERT INTO clients (name, email, phone, address)
     VALUES ($1, $2, $3, $4)
     RETURNING id, name, email, phone, address, created_at`,
    [name, email || null, phone || null, address || null]
  );
  return result.rows[0];
};

export const updateClient = async (id, name, email, phone, address) => {
  const result = await pool.query(
    `UPDATE clients
     SET name    = COALESCE($1, name),
         email   = COALESCE($2, email),
         phone   = COALESCE($3, phone),
         address = COALESCE($4, address)
     WHERE id = $5
     RETURNING id, name, email, phone, address, created_at`,
    [name, email, phone, address, id]
  );
  return result.rows[0];
};

export const deleteClient = async (id) => {
  const result = await pool.query(
    "DELETE FROM clients WHERE id=$1 RETURNING id",
    [id]
  );
  return result.rows[0];
};