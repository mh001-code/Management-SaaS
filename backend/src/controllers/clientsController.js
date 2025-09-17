import pool from "../config/db.js";

// Listar todos os clientes
export const getClients = async (req, res, next) => {
  try {
    const result = await pool.query("SELECT * FROM clients ORDER BY id ASC");
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
};

// Buscar cliente por ID
export const getClientById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM clients WHERE id = $1", [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Cliente não encontrado" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
};

// Criar cliente
export const createClient = async (req, res, next) => {
  try {
    const { name, email, phone, address } = req.body;

    if (!name) {
      return res.status(400).json({ error: "Nome é obrigatório" });
    }

    const result = await pool.query(
      "INSERT INTO clients (name, email, phone, address) VALUES ($1, $2, $3, $4) RETURNING *",
      [name, email || "", phone || "", address || ""]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    if (err.code === "23505") {
      res.status(400).json({ error: "Email já cadastrado" });
    } else {
      next(err);
    }
  }
};

// Atualizar cliente
export const updateClient = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { name, email, phone, address } = req.body;

    const result = await pool.query(
      `UPDATE clients
       SET name = COALESCE($1, name),
           email = COALESCE($2, email),
           phone = COALESCE($3, phone),
           address = COALESCE($4, address)
       WHERE id = $5
       RETURNING *`,
      [name, email, phone, address, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Cliente não encontrado" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    if (err.code === "23505") {
      res.status(400).json({ error: "Email já cadastrado" });
    } else {
      next(err);
    }
  }
};

// Deletar cliente
export const deleteClient = async (req, res, next) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM clients WHERE id = $1 RETURNING id", [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Cliente não encontrado" });
    }

    res.json({ message: "Cliente deletado com sucesso" });
  } catch (err) {
    next(err);
  }
};
