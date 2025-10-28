import * as OrderModel from "../models/OrderModel.js";
import * as OrderItemModel from "../models/OrderItemModel.js";
import * as StockModel from "../models/StockModel.js"; // tabela de movimentações
import * as ProductModel from "../models/ProductModel.js";

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

      await StockModel.addStockMovement({
        product_id: productId,
        quantity: -quantity,
        type: "out",
        reference_id: order.id
      });
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
    res.json(orders);
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

// Atualizar status do pedido
export const updateOrder = async (req, res, next) => {
  try {
    const updatedOrder = await OrderModel.updateOrderStatus(req.params.id, req.body.status);
    if (!updatedOrder) return res.status(404).json({ message: "Pedido não encontrado" });
    res.json(updatedOrder);
  } catch (err) {
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