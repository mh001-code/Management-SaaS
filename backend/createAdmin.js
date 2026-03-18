import pkg from "pg";
import bcrypt from "bcryptjs";
import dotenv from "dotenv";

dotenv.config();

const { Pool } = pkg;

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port: process.env.DB_PORT,
});

const createAdmin = async () => {
  const adminPassword = process.env.ADMIN_PASSWORD;
  const adminEmail = process.env.ADMIN_EMAIL || "admin@seuapp.com";
  const adminName = process.env.ADMIN_NAME || "Admin";

  if (!adminPassword) {
    console.error(
      "❌ ADMIN_PASSWORD não definida no .env\n" +
      "   Adicione ADMIN_PASSWORD=sua_senha_forte ao arquivo .env e tente novamente."
    );
    process.exit(1);
  }

  if (adminPassword.length < 8) {
    console.error("❌ ADMIN_PASSWORD deve ter pelo menos 8 caracteres.");
    process.exit(1);
  }

  try {
    const existing = await pool.query(
      "SELECT id FROM users WHERE email = $1",
      [adminEmail]
    );

    if (existing.rows.length > 0) {
      console.warn(`⚠️  Usuário com email "${adminEmail}" já existe. Nenhuma alteração feita.`);
      return;
    }

    const passwordHash = await bcrypt.hash(adminPassword, 12);

    await pool.query(
      "INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4)",
      [adminName, adminEmail, passwordHash, "admin"]
    );

    console.log(`✅ Admin criado com sucesso! Email: ${adminEmail}`);
  } catch (err) {
    console.error("❌ Erro ao criar admin:", err.message);
    process.exit(1);
  } finally {
    pool.end();
  }
};

createAdmin();