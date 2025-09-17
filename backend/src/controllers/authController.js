import pool from "../config/db.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

export const login = async (req, res, next) => {
  const { email, password } = req.body;

  try {
    // Buscar usuário pelo email
    const result = await pool.query("SELECT * FROM users WHERE email=$1", [email]);
    if (result.rows.length === 0) {
      const error = new Error("Email ou senha incorretos");
      error.statusCode = 401;
      return next(error);
    }

    const user = result.rows[0];

    // Comparar senha
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      const error = new Error("Email ou senha incorretos");
      error.statusCode = 401;
      return next(error);
    }

    // Criar token JWT
    const token = jwt.sign(
      { userId: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: "1h" }
    );

    res.json({ token, user: { id: user.id, name: user.name, email: user.email } });
  } catch (err) {
    next(err);
  }
};
