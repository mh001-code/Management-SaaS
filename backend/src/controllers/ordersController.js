import * as OrderModel from "../models/OrderModel.js";
import * as OrderItemModel from "../models/OrderItemModel.js";
import * as StockModel from "../models/StockModel.js"; // tabela de movimentações
import * as ProductModel from "../models/ProductModel.js";

const normalizeStatus = (status) => {
  if (!status) return "pendente";

  const s = status.toString().toLowerCase();

  if (["pendente", "pending"].includes(s)) return "pendente";
  if (["pago", "paid"].includes(s)) return "pago";
  if (["enviado", "shipped"].includes(s)) return "enviado";
  if (["concluido", "concluído", "completed"].includes(s)) return "concluído";
  if (["cancelado", "canceled"].includes(s)) return "cancelado";

  return s; // fallback
};

// Criar pedido
export const createOrder = async (req, res, next) => {
  const { client_id: clientId, items } = req.body;
  const userId = req.user.userId;

  if (!clientId || !items?.length) {
    return res.status(400).json({ error: "Cliente e itens são obrigatórios" });
  }

  let client;
  try {
    client = await OrderModel.beginTransaction();
    OrderItemModel.setTransactionClient(client);

    let total = 0;

    // 1️⃣ Verifica estoque atual
    for (const item of items) {
      const productId = Number(item.product_id);
      const quantity = Number(item.quantity);

      const stock = await StockModel.getCurrentStock(productId);
      if (stock < quantity) throw new Error(`Estoque insuficiente para o produto ${productId}`);

      total += item.price * quantity;
    }

    // 2️⃣ Cria pedido
    const order = await OrderModel.createOrder(Number(clientId), userId, total);

    // 3️⃣ Cria itens e registra saída no estoque
    for (const item of items) {
      const productId = Number(item.product_id);
      const quantity = Number(item.quantity);
      const price = Number(item.price);

      await OrderItemModel.createOrderItem(order.id, productId, quantity, price);

      await StockModel.decrementStock(productId, quantity);
    }

    await OrderModel.commitTransaction();
    res.status(201).json({ order, items });
  } catch (err) {
    if (client) await OrderModel.rollbackTransaction();
    next(err);
  }
};

// Listar pedidos
export const getOrders = async (req, res, next) => {
  try {
    const orders = await OrderModel.getAllOrdersWithDetails();

    const formatted = orders.map(order => ({
      ...order,
      status: normalizeStatus(order.status),
    }));

    res.json(formatted);
  } catch (err) {
    next(err);
  }
};

// Buscar pedido por ID
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

// Atualizar apenas o status do pedido
export const updateOrderStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    const orderId = req.params.id;

    if (!status)
      return res.status(400).json({ error: "Status é obrigatório." });

    const newStatus = normalizeStatus(status);
    const updated = await OrderModel.updateOrderStatus(orderId, newStatus);

    if (!updated)
      return res.status(404).json({ error: "Pedido não encontrado." });

    res.json({ message: "Status atualizado com sucesso", status: newStatus });
  } catch (err) {
    next(err);
  }
};

// Atualizar status do pedido
export const updateOrder = async (req, res, next) => {
  const { client_id: clientId, items } = req.body;
  const orderId = req.params.id;
  const userId = req.user.userId;

  if (!clientId || !items?.length) {
    return res.status(400).json({ error: "Cliente e itens são obrigatórios" });
  }

  let client;
  try {
    client = await OrderModel.beginTransaction();
    OrderItemModel.setTransactionClient(client);
    StockModel.setTransactionClient(client);

    // 1️⃣ Buscando itens atuais do pedido (trava itens)
    const oldItems = await OrderItemModel.getItemsByOrderId(orderId);

    // 2️⃣ Devolver estoque dos itens antigos
    for (const old of oldItems) {
      await StockModel.restoreStock(old.product_id, old.quantity);
    }

    // 3️⃣ Validar estoque dos novos itens
    for (const item of items) {
      const productId = Number(item.product_id);
      const quantity = Number(item.quantity);

      const stock = await StockModel.getCurrentStockForUpdate(productId);
      if (stock < quantity) {
        throw new Error(
          `Estoque insuficiente para o produto ${productId}. Estoque atual: ${stock}, solicitado: ${quantity}`
        );
      }
    }

    // 4️⃣ Remover itens antigos
    await OrderItemModel.deleteItemsByOrderId(orderId);

    // 5️⃣ Inserir novos itens + calcular total + decrementar estoque
    let total = 0;
    for (const item of items) {
      const productId = Number(item.product_id);
      const quantity = Number(item.quantity);
      const price = Number(item.price);

      total += price * quantity;

      await OrderItemModel.createOrderItem(orderId, productId, quantity, price);
      await StockModel.decrementStock(productId, quantity);
    }

    // 6️⃣ Atualizar pedido (sem mexer no status!)
    await OrderModel.updateOrderClientTotalStatus(orderId, clientId, total, req.body.status || "pendente");

    await OrderModel.commitTransaction();
    res.json({ message: "Pedido atualizado com sucesso" });

  } catch (err) {
    if (client) await OrderModel.rollbackTransaction();
    next(err);
  }
};


// Deletar pedido
export const deleteOrder = async (req, res, next) => {
  try {
    const deletedOrder = await OrderModel.deleteOrder(req.params.id);
    if (!deletedOrder) return res.status(404).json({ message: "Pedido não encontrado" });
    res.json({ message: "Pedido deletado com sucesso" });
  } catch (err) {
    next(err);
  }
};