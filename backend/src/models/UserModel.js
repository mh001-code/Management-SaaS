import pool from "../config/db.js";

export const getAllUsers = async () => {
  const result = await pool.query(
    "SELECT id, name, email, role, created_at FROM users"
  );
  return result.rows;
};

export const getUserById = async (id) => {
  const result = await pool.query(
    "SELECT id, name, email, role, created_at FROM users WHERE id=$1",
    [id]
  );
  return result.rows[0];
};

export const createUser = async (name, email, hashedPassword, role = 'user') => {
  const result = await pool.query(
    "INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4) RETURNING id, name, email, role, created_at",
    [name, email, hashedPassword, role]
  );
  return result.rows[0];
};

export const updateUser = async (id, name, email, hashedPassword, role) => {
  const result = await pool.query(
    `UPDATE users
     SET name = COALESCE($1, name),
         email = COALESCE($2, email),
         password = COALESCE($3, password),
         role = COALESCE($4, role)
     WHERE id=$5
     RETURNING id, name, email, role, created_at`,
    [name, email, hashedPassword, role, id]
  );
  return result.rows[0];
};

export const deleteUser = async (id) => {
  const result = await pool.query(
    "DELETE FROM users WHERE id=$1 RETURNING id",
    [id]
  );
  return result.rows[0];
};

export const getUserByEmail = async (email) => {
  const result = await pool.query(
    "SELECT id, name, email, password, role FROM users WHERE email=$1",
    [email]
  );
  return result.rows[0]; // undefined se não encontrar
};