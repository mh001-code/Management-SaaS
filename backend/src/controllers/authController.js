import pool from "../config/db.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

// Login de usuário
export const login = async (req, res, next) => {
  const { email, password } = req.body;
  console.log("[LOGIN] Iniciando login para:", email); // 🔹 log

  try {
    const result = await pool.query("SELECT * FROM users WHERE email=$1", [email]);
    if (result.rows.length === 0) {
      console.log("[LOGIN] Usuário não encontrado");
      const error = new Error("Email ou senha incorretos");
      error.statusCode = 401;
      return next(error);
    }

    const user = result.rows[0];
    console.log("[LOGIN] Usuário encontrado:", user.email, "Role:", user.role); // 🔹 log

    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      console.log("[LOGIN] Senha incorreta");
      const error = new Error("Email ou senha incorretos");
      error.statusCode = 401;
      return next(error);
    }

    const token = jwt.sign(
      { userId: user.id, email: user.email, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: "1h" }
    );

    console.log("[LOGIN] Token criado:", token); // 🔹 log

    res.json({ token, user: { id: user.id, name: user.name, email: user.email, role: user.role } });
  } catch (err) {
    console.error("[LOGIN] Erro:", err); // 🔹 log
    next(err);
  }
};

// Registrar usuário
export const register = async (req, res, next) => {
  const { name, email, password, role } = req.body;

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    const result = await pool.query(
      "INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4) RETURNING id, name, email, role, created_at",
      [name, email, hashedPassword, role || 'user']
    );

    const newUser = result.rows[0];

    const token = jwt.sign(
      { userId: newUser.id, email: newUser.email, role: newUser.role },
      process.env.JWT_SECRET,
      { expiresIn: "1h" }
    );

    res.status(201).json({ token, user: newUser });
  } catch (err) {
    if (err.code === "23505") {
      return res.status(400).json({ error: "Email já cadastrado" });
    }
    next(err);
  }
};

