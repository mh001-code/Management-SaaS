import * as TM from "../models/TransactionModel.js";

export const getCategories = async (req, res, next) => {
  try {
    res.json(await TM.getAllCategories());
  } catch (err) { next(err); }
};

export const getTransactions = async (req, res, next) => {
  try {
    const { type, status, from, to, category_id } = req.query;
    res.json(await TM.getAllTransactions({ type, status, from, to, category_id }));
  } catch (err) { next(err); }
};

export const getTransactionById = async (req, res, next) => {
  try {
    const t = await TM.getTransactionById(req.params.id);
    if (!t) {
      const e = new Error("Lançamento não encontrado"); e.statusCode = 404; return next(e);
    }
    res.json(t);
  } catch (err) { next(err); }
};

export const createTransaction = async (req, res, next) => {
  try {
    const { type, description, amount, due_date } = req.body;
    if (!type || !description || !amount || !due_date) {
      const e = new Error("Tipo, descrição, valor e vencimento são obrigatórios");
      e.statusCode = 400; return next(e);
    }
    const t = await TM.createTransaction({ ...req.body, user_id: req.user.userId });
    res.status(201).json(t);
  } catch (err) { next(err); }
};

export const updateTransaction = async (req, res, next) => {
  try {
    const updated = await TM.updateTransaction(req.params.id, req.body);
    if (!updated) {
      const e = new Error("Lançamento não encontrado"); e.statusCode = 404; return next(e);
    }
    res.json(updated);
  } catch (err) { next(err); }
};

export const deleteTransaction = async (req, res, next) => {
  try {
    const deleted = await TM.deleteTransaction(req.params.id);
    if (!deleted) {
      const e = new Error("Lançamento não encontrado"); e.statusCode = 404; return next(e);
    }
    res.json({ message: "Lançamento deletado com sucesso" });
  } catch (err) { next(err); }
};

export const getCashFlow = async (req, res, next) => {
  try {
    const from = req.query.from || new Date(new Date().getFullYear(), 0, 1).toISOString().split("T")[0];
    const to   = req.query.to   || new Date().toISOString().split("T")[0];
    res.json(await TM.getCashFlow(from, to));
  } catch (err) { next(err); }
};