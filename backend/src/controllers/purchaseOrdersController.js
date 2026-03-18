import * as POM from "../models/PurchaseOrderModel.js";

const VALID_STATUSES = ["pendente", "confirmado", "recebido", "cancelado"];

const TRANSITIONS = {
  pendente:   ["confirmado", "cancelado"],
  confirmado: ["recebido",   "cancelado"],
  recebido:   [],
  cancelado:  [],
};

export const getPurchaseOrders = async (req, res, next) => {
  try {
    res.json(await POM.getAllPurchaseOrders());
  } catch (err) { next(err); }
};

export const getPurchaseOrderById = async (req, res, next) => {
  try {
    const order = await POM.getPurchaseOrderById(req.params.id);
    if (!order) {
      const e = new Error("Ordem não encontrada"); e.statusCode = 404; return next(e);
    }
    res.json(order);
  } catch (err) { next(err); }
};

export const createPurchaseOrder = async (req, res, next) => {
  const { supplier_id, items, status = "pendente", notes } = req.body;
  if (!supplier_id || !items?.length)
    return res.status(400).json({ error: "Fornecedor e itens são obrigatórios" });

  let tx;
  try {
    tx = await POM.beginTransaction();

    const total = items.reduce((s, i) => s + Number(i.quantity) * Number(i.unit_cost), 0);
    const order = await POM.createPurchaseOrder(tx, supplier_id, req.user.userId, total, status, notes);

    for (const item of items) {
      await POM.createPurchaseOrderItem(
        tx, order.id, item.product_id, item.quantity, item.unit_cost
      );
    }

    await POM.commitTransaction(tx);
    res.status(201).json(order);
  } catch (err) {
    if (tx) await POM.rollbackTransaction(tx);
    next(err);
  }
};

export const updatePurchaseOrderStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    if (!status || !VALID_STATUSES.includes(status))
      return res.status(400).json({ error: "Status inválido" });

    const order = await POM.getPurchaseOrderById(req.params.id);
    if (!order) return res.status(404).json({ error: "Ordem não encontrada" });

    if (!TRANSITIONS[order.status]?.includes(status))
      return res.status(400).json({
        error: `Transição inválida: '${order.status}' → '${status}'`
      });

    if (status === "recebido") {
      await POM.receivePurchaseOrder(order.id);
      return res.json({ message: "Ordem recebida e estoque atualizado", status });
    }

    await POM.updatePurchaseOrderStatus(order.id, status);
    res.json({ message: "Status atualizado", status });
  } catch (err) { next(err); }
};

export const deletePurchaseOrder = async (req, res, next) => {
  try {
    const deleted = await POM.deletePurchaseOrder(req.params.id);
    if (!deleted) {
      const e = new Error("Ordem não encontrada"); e.statusCode = 404; return next(e);
    }
    res.json({ message: "Ordem deletada com sucesso" });
  } catch (err) { next(err); }
};
