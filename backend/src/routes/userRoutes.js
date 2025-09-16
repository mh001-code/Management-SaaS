import express from "express";
import pool from "../config/db.js";

const router = express.Router();

// Exemplo: listar usuários
router.get("/users", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM users");
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Erro no servidor");
  }
});

export default router;
