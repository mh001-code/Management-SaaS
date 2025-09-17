// backend/src/controllers/ordersController.js
import * as OrderModel from "../models/OrderModel.js";
import * as OrderItemModel from "../models/OrderItemModel.js";
import * as StockModel from "../models/StockModel.js";

// Criar pedido
export const createOrder = async (req, res, next) => {
  const { client_id: clientId, items } = req.body;
  const userId = req.user.userId;

  if (!clientId || !items?.length) {
    const error = new Error("Cliente e itens são obrigatórios");
    error.statusCode = 400;
    return next(error);
  }

  try {
    await OrderModel.beginTransaction();

    // Validar estoque e calcular total
    let total = 0;
    for (const item of items) {
      const stock = await StockModel.getStockByProductId(item.product_id);

      if (!stock) throw new Error(`Produto ${item.product_id} não existe no estoque`);
      if (stock.quantity < item.quantity)
        throw new Error(`Estoque insuficiente para o produto ${item.product_id}`);

      total += item.price * item.quantity;
    }

    // Criar pedido
    const order = await OrderModel.createOrder(clientId, userId, total);

    // Criar itens do pedido e atualizar estoque
    for (const item of items) {
      await OrderItemModel.createOrderItem(order.id, item.product_id, item.quantity, item.price);
      await StockModel.decrementStock(item.product_id, item.quantity);
    }

    await OrderModel.commitTransaction();

    res.status(201).json({ order, items });
  } catch (err) {
    await OrderModel.rollbackTransaction();
    next(err);
  }
};

// Listar todos pedidos
export const getOrders = async (req, res, next) => {
  try {
    const orders = await OrderModel.getAllOrders();
    res.json(orders);
  } catch (err) {
    next(err);
  }
};

// Buscar pedido por ID (com itens)
export const getOrderById = async (req, res, next) => {
  try {
    const order = await OrderModel.getOrderById(req.params.id);

    if (!order) {
      const error = new Error("Pedido não encontrado");
      error.statusCode = 404;
      return next(error);
    }

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

    if (!updatedOrder) {
      const error = new Error("Pedido não encontrado");
      error.statusCode = 404;
      return next(error);
    }

    res.json(updatedOrder);
  } catch (err) {
    next(err);
  }
};

// Deletar pedido
export const deleteOrder = async (req, res, next) => {
  try {
    const deletedOrder = await OrderModel.deleteOrder(req.params.id);

    if (!deletedOrder) {
      const error = new Error("Pedido não encontrado");
      error.statusCode = 404;
      return next(error);
    }

    res.json({ message: "Pedido deletado com sucesso" });
  } catch (err) {
    next(err);
  }
};
