import pool from "../config/db.js";
import bcrypt from "bcryptjs";

export const getUsers = async (req, res, next) => {
  try {
    const result = await pool.query("SELECT id, name, email, created_at FROM users");
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
};

export const getUserById = async (req, res, next) => {
  const { id } = req.params;
  try {
    const result = await pool.query("SELECT id, name, email, created_at FROM users WHERE id=$1", [id]);
    if (result.rows.length === 0) {
      const error = new Error("Usuário não encontrado");
      error.statusCode = 404;
      return next(error);
    }
    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
};

export const createUser = async (req, res, next) => {
  const { name, email, password } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const result = await pool.query(
      "INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING id, name, email, created_at",
      [name, email, hashedPassword]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    if (err.code === "23505") {
      const error = new Error("Email já cadastrado");
      error.statusCode = 400;
      return next(error);
    }
    next(err);
  }
};

export const updateUser = async (req, res, next) => {
  const { id } = req.params;
  const { name, email, password } = req.body;
  try {
    const hashedPassword = password ? await bcrypt.hash(password, 10) : undefined;

    const result = await pool.query(
      `UPDATE users 
       SET name = COALESCE($1, name),
           email = COALESCE($2, email),
           password = COALESCE($3, password)
       WHERE id=$4
       RETURNING id, name, email, created_at`,
      [name, email, hashedPassword, id]
    );

    if (result.rows.length === 0) {
      const error = new Error("Usuário não encontrado");
      error.statusCode = 404;
      return next(error);
    }

    res.json(result.rows[0]);
  } catch (err) {
    if (err.code === "23505") {
      const error = new Error("Email já cadastrado");
      error.statusCode = 400;
      return next(error);
    }
    next(err);
  }
};

export const deleteUser = async (req, res, next) => {
  const { id } = req.params;
  try {
    const result = await pool.query("DELETE FROM users WHERE id=$1 RETURNING id", [id]);
    if (result.rows.length === 0) {
      const error = new Error("Usuário não encontrado");
      error.statusCode = 404;
      return next(error);
    }
    res.json({ message: "Usuário deletado com sucesso" });
  } catch (err) {
    next(err);
  }
};
