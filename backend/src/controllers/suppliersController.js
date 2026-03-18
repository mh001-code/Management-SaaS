import * as SupplierModel from "../models/SupplierModel.js";

export const getSuppliers = async (req, res, next) => {
  try {
    res.json(await SupplierModel.getAllSuppliers());
  } catch (err) { next(err); }
};

export const getSupplierById = async (req, res, next) => {
  try {
    const supplier = await SupplierModel.getSupplierById(req.params.id);
    if (!supplier) {
      const e = new Error("Fornecedor não encontrado"); e.statusCode = 404; return next(e);
    }
    res.json(supplier);
  } catch (err) { next(err); }
};

export const createSupplier = async (req, res, next) => {
  try {
    if (!req.body.name) {
      const e = new Error("Nome é obrigatório"); e.statusCode = 400; return next(e);
    }
    res.status(201).json(await SupplierModel.createSupplier(req.body));
  } catch (err) {
    if (err.code === "23505") {
      const e = new Error("E-mail já cadastrado"); e.statusCode = 400; return next(e);
    }
    next(err);
  }
};

export const updateSupplier = async (req, res, next) => {
  try {
    const updated = await SupplierModel.updateSupplier(req.params.id, req.body);
    if (!updated) {
      const e = new Error("Fornecedor não encontrado"); e.statusCode = 404; return next(e);
    }
    res.json(updated);
  } catch (err) {
    if (err.code === "23505") {
      const e = new Error("E-mail já cadastrado"); e.statusCode = 400; return next(e);
    }
    next(err);
  }
};

export const deleteSupplier = async (req, res, next) => {
  try {
    const deleted = await SupplierModel.deleteSupplier(req.params.id);
    if (!deleted) {
      const e = new Error("Fornecedor não encontrado"); e.statusCode = 404; return next(e);
    }
    res.json({ message: "Fornecedor deletado com sucesso" });
  } catch (err) { next(err); }
};
