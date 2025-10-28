import pkg from "pg";
import bcrypt from "bcryptjs";
import dotenv from "dotenv";

dotenv.config();
const { Pool } = pkg;

// Conexão com PostgreSQL via variáveis de ambiente
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port: process.env.DB_PORT,
});

const createAdmin = async () => {
  try {

    // Cria hash da senha
    const passwordHash = await bcrypt.hash("123456", 10);

    // Insere admin
    await pool.query(
      "INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4)",
      ["Admin1", "admin@seuapp.com", passwordHash, "admin"]
    );

    console.log("Admin criado com sucesso!");
  } catch (err) {
    console.error("Erro ao criar admin:", err);
  } finally {
    pool.end();
  }
};

createAdmin();
