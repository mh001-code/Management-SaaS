import * as OrderModel from "../models/OrderModel.js";
import * as OrderItemModel from "../models/OrderItemModel.js";
import * as StockModel from "../models/StockModel.js"; // tabela de movimentações

// =================================
// Normaliza status
// =================================
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

  return s; // fallback
};

// =================================
// Criar pedido
// =================================
export const createOrder = async (req, res, next) => {
  const { client_id: clientId, items, status } = req.body;
  const userId = req.user.userId;

  if (!clientId || !items?.length) {
    return res.status(400).json({ error: "Cliente e itens são obrigatórios" });
  }

  let client;
  try {
    client = await OrderModel.beginTransaction();
    OrderItemModel.setTransactionClient(client);

    let total = 0;

    // 1️⃣ Verifica estoque atual (não decrementa ainda, só quando pago)
    for (const item of items) {
      const productId = Number(item.product_id);
      const quantity = Number(item.quantity);

      const stock = await StockModel.getCurrentStock(productId);
      if (stock < quantity) throw new Error(`Estoque insuficiente para o produto ${productId}`);

      total += item.price * quantity;
    }

    // 2️⃣ Cria pedido com status fornecido ou padrão "pendente"
    const normalizedStatus = normalizeStatus(status) || 'pendente';
    const order = await OrderModel.createOrder(Number(clientId), userId, total, normalizedStatus);

    // 3️⃣ Cria itens (estoque será decrementado apenas ao pagar)
    for (const item of items) {
      const productId = Number(item.product_id);
      const quantity = Number(item.quantity);
      const price = Number(item.price);

      await OrderItemModel.createOrderItem(order.id, productId, quantity, price);
    }

    await OrderModel.commitTransaction();
    res.status(201).json({ order, items });

  } catch (err) {
    if (client) await OrderModel.rollbackTransaction();
    next(err);
  }
};

// =================================
// Listar todos os pedidos
// =================================
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

// =================================
// Buscar pedido por ID
// =================================
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

// =================================
// Atualizar apenas o status do pedido
// =================================
export const updateOrderStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    const orderId = req.params.id;

    if (!status) return res.status(400).json({ error: "Status é obrigatório." });

    const newStatus = normalizeStatus(status);

    // ✅ Lista de status válidos
    const allowedStatuses = ["pendente", "pago", "enviado", "entregue", "concluído", "cancelado", "estornado", "recusado"];
    if (!allowedStatuses.includes(newStatus)) {
      return res.status(400).json({ error: "Status inválido" });
    }

    // 1️⃣ Busca pedido atual
    const order = await OrderModel.getOrderById(orderId);
    if (!order) return res.status(404).json({ error: "Pedido não encontrado." });

    const oldStatus = normalizeStatus(order.status);

    // 🔐 Tabela de transições permitidas
    const transitions = {
      pendente: ["pago", "cancelado"],
      pago: ["enviado", "cancelado"],
      enviado: ["entregue", "estornado", "recusado", "cancelado"],
      entregue: ["estornado", "cancelado"],
      concluído: [],
      cancelado: [],
      estornado: [],
      recusado: []
    };

    if (!transitions[oldStatus].includes(newStatus)) {
      console.warn(`Tentativa de transição inválida: ${oldStatus} → ${newStatus}`);
      return res.status(400).json({
        error: `Transição inválida: não é permitido alterar de '${oldStatus}' para '${newStatus}'.`
      });
    }

    // 2️⃣ Buscar itens do pedido
    const items = await OrderItemModel.getItemsByOrderId(orderId);

    // 3️⃣ Regras de estoque
    // Regras de estoque
    if (oldStatus !== "pago" && newStatus === "pago") {
      // Pendente → Pago
      for (const item of items) {
        await StockModel.decrementStock(item.product_id, item.quantity);
      }
    }

    // Restaurar estoque em situações que devolvem os itens
    const shouldRestoreStock =
      (oldStatus === "pago" && newStatus === "cancelado") ||
      (oldStatus === "enviado" && newStatus === "estornado") ||
      (oldStatus === "entregue" && newStatus === "estornado");

    if (shouldRestoreStock) {
      for (const item of items) {
        await StockModel.restoreStock(item.product_id, item.quantity);
      }
    }

    // 4️⃣ Atualiza status
    await OrderModel.updateOrderStatus(orderId, newStatus);

    res.json({ message: "Status atualizado com sucesso", status: newStatus });

  } catch (err) {
    next(err);
  }
};

// =================================
// Atualizar pedido completo (itens + cliente)
// =================================
export const updateOrder = async (req, res, next) => {
  const { client_id: clientId, items, status } = req.body;
  const orderId = req.params.id;

  if (!clientId || !items?.length) {
    return res.status(400).json({ error: "Cliente e itens são obrigatórios" });
  }

  let client;
  try {
    client = await OrderModel.beginTransaction();
    OrderItemModel.setTransactionClient(client);
    StockModel.setTransactionClient(client);

    // 1️⃣ Buscar itens atuais
    const oldItems = await OrderItemModel.getItemsByOrderId(orderId);

    // 2️⃣ Devolver estoque antigo apenas se pedido estava pago
    const order = await OrderModel.getOrderById(orderId);
    if (normalizeStatus(order.status) === "pago") {
      for (const old of oldItems) {
        await StockModel.restoreStock(old.product_id, old.quantity);
      }
    }

    // 3️⃣ Validar estoque dos novos itens
    for (const item of items) {
      const productId = Number(item.product_id);
      const quantity = Number(item.quantity);
      const stock = await StockModel.getCurrentStockForUpdate(productId);
      if (stock < quantity) {
        throw new Error(`Estoque insuficiente para o produto ${productId}. Estoque atual: ${stock}, solicitado: ${quantity}`);
      }
    }

    // 4️⃣ Remover itens antigos
    await OrderItemModel.deleteItemsByOrderId(orderId);

    // 5️⃣ Inserir novos itens + calcular total
    let total = 0;
    for (const item of items) {
      const productId = Number(item.product_id);
      const quantity = Number(item.quantity);
      const price = Number(item.price);

      total += price * quantity;
      await OrderItemModel.createOrderItem(orderId, productId, quantity, price);
    }

    // 6️⃣ Atualizar pedido com status fornecido ou mantém o antigo
    const newStatus = status ? normalizeStatus(status) : normalizeStatus(order.status);
    await OrderModel.updateOrderClientTotalStatus(orderId, clientId, total, newStatus);

    await OrderModel.commitTransaction();
    res.json({ message: "Pedido atualizado com sucesso" });

  } catch (err) {
    if (client) await OrderModel.rollbackTransaction();
    next(err);
  }
};

// =================================
// Deletar pedido
// =================================
export const deleteOrder = async (req, res, next) => {
  try {
    const deletedOrder = await OrderModel.deleteOrder(req.params.id);
    if (!deletedOrder) return res.status(404).json({ message: "Pedido não encontrado" });

    res.json({ message: "Pedido deletado com sucesso" });
  } catch (err) {
    next(err);
  }
};