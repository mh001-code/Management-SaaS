import * as OrderModel from "../models/OrderModel.js";
import * as OrderItemModel from "../models/OrderItemModel.js";
import * as StockModel from "../models/StockModel.js";
import * as TM from "../models/TransactionModel.js";
import pool from "../config/db.js";

const normalizeStatus = (status) => {
  if (!status) return "pendente";
  const s = status.toString().toLowerCase();
  if (["pendente","pending"].includes(s)) return "pendente";
  if (["pago","paid"].includes(s)) return "pago";
  if (["enviado","shipped"].includes(s)) return "enviado";
  if (["entregue","delivered"].includes(s)) return "entregue";
  if (["concluido","concluído","completed"].includes(s)) return "concluído";
  if (["cancelado","canceled"].includes(s)) return "cancelado";
  if (["estornado","refunded"].includes(s)) return "estornado";
  if (["recusado","rejected"].includes(s)) return "recusado";
  return s;
};

const getClientName = async (clientId) => {
  const res = await pool.query("SELECT name FROM clients WHERE id = $1", [clientId]);
  return res.rows[0]?.name ?? "cliente";
};

export const createOrder = async (req, res, next) => {
  const { client_id: clientId, items, status } = req.body;
  const userId = req.user.userId;
  if (!clientId || !items?.length) {
    return res.status(400).json({ error: "Cliente e itens são obrigatórios" });
  }
  let txClient;
  try {
    txClient = await OrderModel.beginTransaction();
    let total = 0;
    const normalizedStatus = normalizeStatus(status) || "pendente";
    for (const item of items) {
      const productId = Number(item.product_id);
      const quantity  = Number(item.quantity);
      const stock     = await StockModel.getCurrentStock(productId, txClient);
      if (stock < quantity) throw new Error(`Estoque insuficiente para o produto ${productId}. Disponível: ${stock}, solicitado: ${quantity}`);
      total += item.price * quantity;
    }
    const order = await OrderModel.createOrder(txClient, Number(clientId), userId, total, normalizedStatus);
    for (const item of items) {
      await OrderItemModel.createOrderItem(order.id, Number(item.product_id), Number(item.quantity), Number(item.price), txClient);
      await StockModel.decrementStock(Number(item.product_id), Number(item.quantity), txClient);
    }
    await OrderModel.commitTransaction(txClient);
    if (normalizedStatus === "pago") {
      const clientName = await getClientName(Number(clientId));
      await TM.createReceivableFromOrder({ id: order.id, total, client_id: Number(clientId), client_name: clientName }, userId);
    }
    res.status(201).json({ order, items });
  } catch (err) {
    if (txClient) await OrderModel.rollbackTransaction(txClient);
    next(err);
  }
};

export const getOrders = async (req, res, next) => {
  try {
    const orders = await OrderModel.getAllOrdersWithDetails();
    res.json(orders.map((o) => ({ ...o, status: normalizeStatus(o.status) })));
  } catch (err) { next(err); }
};

export const getOrderById = async (req, res, next) => {
  try {
    const order = await OrderModel.getOrderById(req.params.id);
    if (!order) return res.status(404).json({ message: "Pedido não encontrado" });
    order.items = await OrderItemModel.getItemsByOrderId(order.id);
    res.json(order);
  } catch (err) { next(err); }
};

export const updateOrderStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    const orderId = req.params.id;
    if (!status) return res.status(400).json({ error: "Status é obrigatório." });
    const newStatus = normalizeStatus(status);
    const allowed = ["pendente","pago","enviado","entregue","concluído","cancelado","estornado","recusado"];
    if (!allowed.includes(newStatus)) return res.status(400).json({ error: "Status inválido" });
    const order = await OrderModel.getOrderById(orderId);
    if (!order) return res.status(404).json({ error: "Pedido não encontrado." });
    const oldStatus = normalizeStatus(order.status);
    const transitions = {
      pendente: ["pago","cancelado"],
      pago: ["enviado","cancelado"],
      enviado: ["entregue","estornado","recusado","cancelado"],
      entregue: ["estornado","cancelado"],
      concluído: [], cancelado: [], estornado: [], recusado: [],
    };
    if (!transitions[oldStatus]?.includes(newStatus)) {
      return res.status(400).json({ error: `Transição inválida: não é permitido alterar de '${oldStatus}' para '${newStatus}'.` });
    }
    const items = await OrderItemModel.getItemsByOrderId(orderId);
    const shouldRestore =
      (oldStatus === "pendente" && newStatus === "cancelado") ||
      (oldStatus === "pago" && newStatus === "cancelado") ||
      (oldStatus === "enviado" && ["estornado","recusado","cancelado"].includes(newStatus)) ||
      (oldStatus === "entregue" && newStatus === "estornado");
    if (shouldRestore) {
      for (const item of items) await StockModel.restoreStock(item.product_id, item.quantity);
    }
    await OrderModel.updateOrderStatus(orderId, newStatus);
    if (newStatus === "pago") {
      const clientName = await getClientName(order.client_id);
      await TM.createReceivableFromOrder({ id: order.id, total: Number(order.total), client_id: order.client_id, client_name: clientName }, req.user.userId);
    }
    if (["cancelado","estornado","recusado"].includes(newStatus)) {
      await pool.query(`UPDATE transactions SET status = 'cancelado', updated_at = NOW() WHERE order_id = $1 AND type = 'receita' AND status != 'cancelado'`, [orderId]);
    }
    res.json({ message: "Status atualizado com sucesso", status: newStatus });
  } catch (err) { next(err); }
};

export const updateOrder = async (req, res, next) => {
  const { client_id: clientId, items, status } = req.body;
  const orderId = req.params.id;
  if (!clientId || !items?.length) return res.status(400).json({ error: "Cliente e itens são obrigatórios" });
  let txClient;
  try {
    txClient = await OrderModel.beginTransaction();
    const oldItems = await OrderItemModel.getItemsByOrderId(orderId, txClient);
    for (const old of oldItems) await StockModel.restoreStock(old.product_id, old.quantity, txClient);
    for (const item of items) {
      const productId = Number(item.product_id);
      const quantity  = Number(item.quantity);
      const stock     = await StockModel.getCurrentStockForUpdate(productId, txClient);
      if (stock < quantity) throw new Error(`Estoque insuficiente para o produto ${productId}. Disponível: ${stock}, solicitado: ${quantity}`);
    }
    await OrderItemModel.deleteItemsByOrderId(orderId, txClient);
    let total = 0;
    for (const item of items) {
      const productId = Number(item.product_id), quantity = Number(item.quantity), price = Number(item.price);
      total += price * quantity;
      await OrderItemModel.createOrderItem(orderId, productId, quantity, price, txClient);
      await StockModel.decrementStock(productId, quantity, txClient);
    }
    const order = await OrderModel.getOrderById(orderId);
    const newStatus = status ? normalizeStatus(status) : normalizeStatus(order.status);
    await OrderModel.updateOrderClientTotalStatus(txClient, orderId, clientId, total, newStatus);
    await OrderModel.commitTransaction(txClient);
    res.json({ message: "Pedido atualizado com sucesso" });
  } catch (err) {
    if (txClient) await OrderModel.rollbackTransaction(txClient);
    next(err);
  }
};

export const deleteOrder = async (req, res, next) => {
  try {
    const deleted = await OrderModel.deleteOrder(req.params.id);
    if (!deleted) return res.status(404).json({ message: "Pedido não encontrado" });
    res.json({ message: "Pedido deletado com sucesso" });
  } catch (err) { next(err); }
};
