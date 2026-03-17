import * as OrderModel from "../models/OrderModel.js";
import * as OrderItemModel from "../models/OrderItemModel.js";
import * as StockModel from "../models/StockModel.js";

// ─── Normaliza status ─────────────────────────────────────────────────────────
const normalizeStatus = (status) => {
  if (!status) return "pendente";
  const s = status.toString().toLowerCase();
  if (["pendente", "pending"].includes(s)) return "pendente";
  if (["pago", "paid"].includes(s)) return "pago";
  if (["enviado", "shipped"].includes(s)) return "enviado";
  if (["entregue", "delivered"].includes(s)) return "entregue";
  if (["concluido", "concluído", "completed"].includes(s)) return "concluído";
  if (["cancelado", "canceled"].includes(s)) return "cancelado";
  if (["estornado", "refunded"].includes(s)) return "estornado";
  if (["recusado", "rejected"].includes(s)) return "recusado";
  return s;
};

// ─── Criar pedido ─────────────────────────────────────────────────────────────
export const createOrder = async (req, res, next) => {
  const { client_id: clientId, items, status } = req.body;
  const userId = req.user.userId;

  if (!clientId || !items?.length) {
    return res.status(400).json({ error: "Cliente e itens são obrigatórios" });
  }

  // ✅ client é local — sem estado global
  let txClient;
  try {
    txClient = await OrderModel.beginTransaction();

    let total = 0;

    for (const item of items) {
      const productId = Number(item.product_id);
      const quantity = Number(item.quantity);
      // ✅ passa txClient explicitamente
      const stock = await StockModel.getCurrentStock(productId, txClient);
      if (stock < quantity) {
        throw new Error(`Estoque insuficiente para o produto ${productId}`);
      }
      total += item.price * quantity;
    }

    const normalizedStatus = normalizeStatus(status) || "pendente";
    const order = await OrderModel.createOrder(
      txClient,
      Number(clientId),
      userId,
      total,
      normalizedStatus
    );

    for (const item of items) {
      await OrderItemModel.createOrderItem(
        order.id,
        Number(item.product_id),
        Number(item.quantity),
        Number(item.price),
        txClient // ✅
      );
    }

    await OrderModel.commitTransaction(txClient);
    res.status(201).json({ order, items });
  } catch (err) {
    if (txClient) await OrderModel.rollbackTransaction(txClient);
    next(err);
  }
};

// ─── Listar pedidos ───────────────────────────────────────────────────────────
export const getOrders = async (req, res, next) => {
  try {
    const orders = await OrderModel.getAllOrdersWithDetails();
    const formatted = orders.map((order) => ({
      ...order,
      status: normalizeStatus(order.status),
    }));
    res.json(formatted);
  } catch (err) {
    next(err);
  }
};

// ─── Buscar pedido por ID ─────────────────────────────────────────────────────
export const getOrderById = async (req, res, next) => {
  try {
    const order = await OrderModel.getOrderById(req.params.id);
    if (!order) return res.status(404).json({ message: "Pedido não encontrado" });

    const items = await OrderItemModel.getItemsByOrderId(order.id);
    order.items = items;
    res.json(order);
  } catch (err) {
    next(err);
  }
};

// ─── Atualizar status ─────────────────────────────────────────────────────────
export const updateOrderStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    const orderId = req.params.id;

    if (!status) return res.status(400).json({ error: "Status é obrigatório." });

    const newStatus = normalizeStatus(status);

    const allowedStatuses = [
      "pendente", "pago", "enviado", "entregue",
      "concluído", "cancelado", "estornado", "recusado",
    ];
    if (!allowedStatuses.includes(newStatus)) {
      return res.status(400).json({ error: "Status inválido" });
    }

    const order = await OrderModel.getOrderById(orderId);
    if (!order) return res.status(404).json({ error: "Pedido não encontrado." });

    const oldStatus = normalizeStatus(order.status);

    const transitions = {
      pendente:  ["pago", "cancelado"],
      pago:      ["enviado", "cancelado"],
      enviado:   ["entregue", "estornado", "recusado", "cancelado"],
      entregue:  ["estornado", "cancelado"],
      concluído: [],
      cancelado: [],
      estornado: [],
      recusado:  [],
    };

    if (!transitions[oldStatus]?.includes(newStatus)) {
      return res.status(400).json({
        error: `Transição inválida: não é permitido alterar de '${oldStatus}' para '${newStatus}'.`,
      });
    }

    const items = await OrderItemModel.getItemsByOrderId(orderId);

    if (oldStatus !== "pago" && newStatus === "pago") {
      for (const item of items) {
        await StockModel.decrementStock(item.product_id, item.quantity);
      }
    }

    const shouldRestoreStock =
      (oldStatus === "pago" && newStatus === "cancelado") ||
      (oldStatus === "enviado" && newStatus === "estornado") ||
      (oldStatus === "entregue" && newStatus === "estornado");

    if (shouldRestoreStock) {
      for (const item of items) {
        await StockModel.restoreStock(item.product_id, item.quantity);
      }
    }

    await OrderModel.updateOrderStatus(orderId, newStatus);
    res.json({ message: "Status atualizado com sucesso", status: newStatus });
  } catch (err) {
    next(err);
  }
};

// ─── Atualizar pedido completo ────────────────────────────────────────────────
export const updateOrder = async (req, res, next) => {
  const { client_id: clientId, items, status } = req.body;
  const orderId = req.params.id;

  if (!clientId || !items?.length) {
    return res.status(400).json({ error: "Cliente e itens são obrigatórios" });
  }

  // ✅ client é local — sem estado global
  let txClient;
  try {
    txClient = await OrderModel.beginTransaction();

    const oldItems = await OrderItemModel.getItemsByOrderId(orderId, txClient); // ✅
    const order = await OrderModel.getOrderById(orderId);

    if (normalizeStatus(order.status) === "pago") {
      for (const old of oldItems) {
        await StockModel.restoreStock(old.product_id, old.quantity, txClient); // ✅
      }
    }

    for (const item of items) {
      const productId = Number(item.product_id);
      const quantity = Number(item.quantity);
      const stock = await StockModel.getCurrentStockForUpdate(productId, txClient); // ✅
      if (stock < quantity) {
        throw new Error(
          `Estoque insuficiente para o produto ${productId}. Disponível: ${stock}, solicitado: ${quantity}`
        );
      }
    }

    await OrderItemModel.deleteItemsByOrderId(orderId, txClient); // ✅

    let total = 0;
    for (const item of items) {
      const productId = Number(item.product_id);
      const quantity = Number(item.quantity);
      const price = Number(item.price);
      total += price * quantity;
      await OrderItemModel.createOrderItem(orderId, productId, quantity, price, txClient); // ✅
    }

    const newStatus = status ? normalizeStatus(status) : normalizeStatus(order.status);
    await OrderModel.updateOrderClientTotalStatus(txClient, orderId, clientId, total, newStatus); // ✅

    await OrderModel.commitTransaction(txClient);
    res.json({ message: "Pedido atualizado com sucesso" });
  } catch (err) {
    if (txClient) await OrderModel.rollbackTransaction(txClient);
    next(err);
  }
};

// ─── Deletar pedido ───────────────────────────────────────────────────────────
export const deleteOrder = async (req, res, next) => {
  try {
    const deletedOrder = await OrderModel.deleteOrder(req.params.id);
    if (!deletedOrder) {
      return res.status(404).json({ message: "Pedido não encontrado" });
    }
    res.json({ message: "Pedido deletado com sucesso" });
  } catch (err) {
    next(err);
  }
};