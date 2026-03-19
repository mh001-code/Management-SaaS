import * as ClientModel from "../models/ClientModel.js";
import pool from "../config/db.js";

export const getClients = async (req, res, next) => {
  try { res.json(await ClientModel.getAllClients()); } catch (err) { next(err); }
};

export const getClientById = async (req, res, next) => {
  try {
    const client = await ClientModel.getClientById(req.params.id);
    if (!client) { const e = new Error("Cliente não encontrado"); e.statusCode = 404; return next(e); }
    res.json(client);
  } catch (err) { next(err); }
};

export const createClient = async (req, res, next) => {
  try {
    const { name, email, phone, address } = req.body;
    if (!name || !name.trim()) {
      const e = new Error("Nome do cliente é obrigatório"); e.statusCode = 400; return next(e);
    }

    // Email único (se fornecido)
    if (email) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email)) {
        const e = new Error("Formato de e-mail inválido"); e.statusCode = 400; return next(e);
      }
    }

    const client = await ClientModel.createClient(name.trim(), email || null, phone || null, address || null);
    res.status(201).json(client);
  } catch (err) {
    if (err.code === "23505") {
      const e = new Error("E-mail já cadastrado para outro cliente"); e.statusCode = 409; return next(e);
    }
    next(err);
  }
};

export const updateClient = async (req, res, next) => {
  try {
    const { name, email, phone, address } = req.body;

    if (email) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email)) {
        const e = new Error("Formato de e-mail inválido"); e.statusCode = 400; return next(e);
      }
    }

    const updated = await ClientModel.updateClient(req.params.id, name, email, phone, address);
    if (!updated) { const e = new Error("Cliente não encontrado"); e.statusCode = 404; return next(e); }
    res.json(updated);
  } catch (err) {
    if (err.code === "23505") {
      const e = new Error("E-mail já cadastrado para outro cliente"); e.statusCode = 409; return next(e);
    }
    next(err);
  }
};

export const deleteClient = async (req, res, next) => {
  try {
    // Não permite deletar cliente com pedidos ativos
    const active = await pool.query(
      `SELECT COUNT(*) FROM orders
       WHERE client_id = $1 AND status NOT IN ('cancelado','estornado','recusado')`,
      [req.params.id]
    );
    if (Number(active.rows[0].count) > 0) {
      const e = new Error("Não é possível excluir cliente com pedidos ativos");
      e.statusCode = 409; return next(e);
    }

    const deleted = await ClientModel.deleteClient(req.params.id);
    if (!deleted) { const e = new Error("Cliente não encontrado"); e.statusCode = 404; return next(e); }
    res.json({ message: "Cliente deletado com sucesso" });
  } catch (err) { next(err); }
};