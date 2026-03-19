import * as TM from "../models/TransactionModel.js";

export const getCategories = async (req, res, next) => {
  try { res.json(await TM.getAllCategories()); } catch (err) { next(err); }
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
    if (!t) { const e = new Error("Lançamento não encontrado"); e.statusCode = 404; return next(e); }
    res.json(t);
  } catch (err) { next(err); }
};

export const createTransaction = async (req, res, next) => {
  try {
    const { type, description, amount, due_date, paid_date, status } = req.body;

    // ── Regras de negócio ──────────────────────────────────────────────────
    if (!type || !description || !amount || !due_date) {
      const e = new Error("Tipo, descrição, valor e vencimento são obrigatórios");
      e.statusCode = 400; return next(e);
    }
    if (Number(amount) <= 0) {
      const e = new Error("Valor do lançamento deve ser maior que zero");
      e.statusCode = 400; return next(e);
    }
    if (!["receita", "despesa"].includes(type)) {
      const e = new Error("Tipo deve ser 'receita' ou 'despesa'");
      e.statusCode = 400; return next(e);
    }

    // Data de pagamento não pode ser anterior ao vencimento
    if (paid_date && due_date && new Date(paid_date) < new Date(due_date)) {
      const e = new Error("Data de pagamento não pode ser anterior ao vencimento");
      e.statusCode = 400; return next(e);
    }

    // Aviso: vencimento no passado com status pendente → força 'vencido'
    const resolvedStatus = (() => {
      if (status && status !== "pendente") return status;
      if (due_date && new Date(due_date) < new Date(new Date().toDateString())) return "vencido";
      return status || "pendente";
    })();

    const t = await TM.createTransaction({ ...req.body, status: resolvedStatus, user_id: req.user.userId });
    res.status(201).json(t);
  } catch (err) { next(err); }
};

export const updateTransaction = async (req, res, next) => {
  try {
    const { amount, paid_date, due_date, status } = req.body;

    if (amount !== undefined && Number(amount) <= 0) {
      const e = new Error("Valor deve ser maior que zero"); e.statusCode = 400; return next(e);
    }

    // Data pagamento consistente com vencimento
    const existing = await TM.getTransactionById(req.params.id);
    if (!existing) { const e = new Error("Lançamento não encontrado"); e.statusCode = 404; return next(e); }

    const effectiveDue  = due_date  || existing.due_date;
    const effectivePaid = paid_date !== undefined ? paid_date : existing.paid_date;

    if (effectivePaid && effectiveDue && new Date(effectivePaid) < new Date(effectiveDue)) {
      const e = new Error("Data de pagamento não pode ser anterior ao vencimento");
      e.statusCode = 400; return next(e);
    }

    // Não permite reabrir lançamento cancelado
    if (existing.status === "cancelado" && status && status !== "cancelado") {
      const e = new Error("Não é possível reativar um lançamento cancelado");
      e.statusCode = 409; return next(e);
    }

    const updated = await TM.updateTransaction(req.params.id, req.body);
    res.json(updated);
  } catch (err) { next(err); }
};

export const deleteTransaction = async (req, res, next) => {
  try {
    // Não permite deletar lançamento pago
    const t = await TM.getTransactionById(req.params.id);
    if (!t) { const e = new Error("Lançamento não encontrado"); e.statusCode = 404; return next(e); }

    if (t.status === "pago") {
      const e = new Error("Não é possível excluir um lançamento já pago. Cancele-o se necessário.");
      e.statusCode = 409; return next(e);
    }

    await TM.deleteTransaction(req.params.id);
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