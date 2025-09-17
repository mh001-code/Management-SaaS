import pool from "../config/db.js";

export const getAllUsers = async () => {
  const result = await pool.query("SELECT id, name, email, created_at FROM users");
  return result.rows;
};

export const getUserById = async (id) => {
  const result = await pool.query("SELECT id, name, email, created_at FROM users WHERE id=$1", [id]);
  return result.rows[0];
};

export const createUser = async (name, email, hashedPassword) => {
  const result = await pool.query(
    "INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING id, name, email, created_at",
    [name, email, hashedPassword]
  );
  return result.rows[0];
};

export const updateUser = async (id, name, email, hashedPassword) => {
  const result = await pool.query(
    `UPDATE users
     SET name = COALESCE($1, name),
         email = COALESCE($2, email),
         password = COALESCE($3, password)
     WHERE id=$4
     RETURNING id, name, email, created_at`,
    [name, email, hashedPassword, id]
  );
  return result.rows[0];
};

export const deleteUser = async (id) => {
  const result = await pool.query("DELETE FROM users WHERE id=$1 RETURNING id", [id]);
  return result.rows[0];
};
