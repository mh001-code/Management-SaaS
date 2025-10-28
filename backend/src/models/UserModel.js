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

export const updateUser = async (id, name, email, password, role) => {
  try {
    console.log("\n[UPDATE USER] Iniciando atualização...");
    console.log("[UPDATE USER] Parâmetros recebidos:", { id, name, email, password, role });

    const fields = [];
    const values = [];
    let idx = 1;

    if (typeof name !== "undefined" && name.trim() !== "") {
      fields.push(`name=$${idx++}`);
      values.push(name);
    }

    if (typeof email !== "undefined" && email.trim() !== "") {
      fields.push(`email=$${idx++}`);
      values.push(email);
    }

    if (typeof password !== "undefined" && password.trim() !== "") {
      fields.push(`password=$${idx++}`);
      values.push(password);
    }

    if (typeof role !== "undefined" && role.trim() !== "") {
      fields.push(`role=$${idx++}`);
      values.push(role);
    }

    if (fields.length === 0) {
      console.warn("[UPDATE USER] Nenhum campo alterado, retornando usuário atual.");
      const { rows } = await pool.query(
        "SELECT id, name, email, role FROM users WHERE id=$1",
        [id]
      );
      return rows[0];
    }

    const query = `UPDATE users SET ${fields.join(", ")} WHERE id=$${idx} RETURNING id, name, email, role`;
    values.push(id);

    console.log("[UPDATE USER] Query gerada:", query);
    console.log("[UPDATE USER] Valores enviados:", values);

    const result = await pool.query(query, values);

    console.log("[UPDATE USER] Resultado do banco:", result.rows[0]);
    return result.rows[0];
  } catch (err) {
    console.error("[UPDATE USER] ERRO SQL DETALHADO:");
    console.error("→ Mensagem:", err.message);
    console.error("→ Código:", err.code);
    console.error("→ Detalhe:", err.detail);
    console.error("→ Stack:", err.stack);
    throw err;
  }
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