import * as SupplierModel from "../models/SupplierModel.js";
import pool from "../config/db.js";

export const getSuppliers = async (req, res, next) => {
  try { res.json(await SupplierModel.getAllSuppliers()); } catch (err) { next(err); }
};

export const getSupplierById = async (req, res, next) => {
  try {
    const supplier = await SupplierModel.getSupplierById(req.params.id);
    if (!supplier) { const e = new Error("Fornecedor não encontrado"); e.statusCode = 404; return next(e); }
    res.json(supplier);
  } catch (err) { next(err); }
};

export const createSupplier = async (req, res, next) => {
  try {
    if (!req.body.name || !req.body.name.trim()) {
      const e = new Error("Nome do fornecedor é obrigatório"); e.statusCode = 400; return next(e);
    }
    if (req.body.email) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(req.body.email)) {
        const e = new Error("Formato de e-mail inválido"); e.statusCode = 400; return next(e);
      }
    }
    res.status(201).json(await SupplierModel.createSupplier(req.body));
  } catch (err) {
    if (err.code === "23505") {
      const e = new Error("E-mail já cadastrado para outro fornecedor"); e.statusCode = 409; return next(e);
    }
    next(err);
  }
};

export const updateSupplier = async (req, res, next) => {
  try {
    if (req.body.email) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(req.body.email)) {
        const e = new Error("Formato de e-mail inválido"); e.statusCode = 400; return next(e);
      }
    }
    const updated = await SupplierModel.updateSupplier(req.params.id, req.body);
    if (!updated) { const e = new Error("Fornecedor não encontrado"); e.statusCode = 404; return next(e); }
    res.json(updated);
  } catch (err) {
    if (err.code === "23505") {
      const e = new Error("E-mail já cadastrado para outro fornecedor"); e.statusCode = 409; return next(e);
    }
    next(err);
  }
};

export const deleteSupplier = async (req, res, next) => {
  try {
    // Não permite deletar fornecedor com pedidos de compra ativos
    const active = await pool.query(
      `SELECT COUNT(*) FROM purchase_orders
       WHERE supplier_id = $1 AND status NOT IN ('cancelado')`,
      [req.params.id]
    );
    if (Number(active.rows[0].count) > 0) {
      const e = new Error("Não é possível excluir fornecedor com pedidos de compra ativos");
      e.statusCode = 409; return next(e);
    }
    const deleted = await SupplierModel.deleteSupplier(req.params.id);
    if (!deleted) { const e = new Error("Fornecedor não encontrado"); e.statusCode = 404; return next(e); }
    res.json({ message: "Fornecedor deletado com sucesso" });
  } catch (err) { next(err); }
};