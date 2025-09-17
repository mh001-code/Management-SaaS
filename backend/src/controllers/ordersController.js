import pool from "../config/db.js";

// Criar pedido
export const createOrder = async (req, res, next) => {
  const client = req.body.client_id;
  const items = req.body.items;
  const user_id = req.user.userId;

  try {
    if (!client || !items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ error: "Cliente e itens são obrigatórios" });
    }

    // Iniciar transação
    await pool.query("BEGIN");

    // Checar estoque disponível e calcular total
    let total = 0;
    for (const item of items) {
      const productStock = await pool.query(
        "SELECT quantity FROM stock WHERE product_id=$1",
        [item.product_id]
      );

      if (productStock.rows.length === 0) {
        throw new Error(`Produto ${item.product_id} não existe no estoque`);
      }

      if (productStock.rows[0].quantity < item.quantity) {
        throw new Error(`Estoque insuficiente para o produto ${item.product_id}`);
      }

      total += item.price * item.quantity;
    }

    // Criar pedido
    const orderResult = await pool.query(
      "INSERT INTO orders (client_id, user_id, total) VALUES ($1, $2, $3) RETURNING *",
      [client, user_id, total]
    );
    const orderId = orderResult.rows[0].id;

    // Criar itens do pedido e decrementar estoque
    for (const item of items) {
      await pool.query(
        "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES ($1, $2, $3, $4)",
        [orderId, item.product_id, item.quantity, item.price]
      );

      await pool.query(
        "UPDATE stock SET quantity = quantity - $1, last_updated=NOW() WHERE product_id=$2",
        [item.quantity, item.product_id]
      );
    }

    // Commit da transação
    await pool.query("COMMIT");

    res.status(201).json({ order: orderResult.rows[0], items });
  } catch (err) {
    await pool.query("ROLLBACK");
    next(err);
  }
};

// Listar todos pedidos
export const getOrders = async (req, res, next) => {
  try {
    const result = await pool.query(
      "SELECT o.id, o.client_id, o.user_id, o.total, o.status, o.created_at FROM orders o ORDER BY o.id ASC"
    );
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
};

// Buscar pedido por ID (com itens)
export const getOrderById = async (req, res, next) => {
  try {
    const { id } = req.params;

    // Buscar pedido
    const orderResult = await pool.query(
      "SELECT * FROM orders WHERE id = $1",
      [id]
    );

    if (orderResult.rows.length === 0) {
      return res.status(404).json({ error: "Pedido não encontrado" });
    }

    const order = orderResult.rows[0];

    // Buscar itens do pedido
    const itemsResult = await pool.query(
      "SELECT oi.id, oi.product_id, p.name as product_name, oi.quantity, oi.price " +
      "FROM order_items oi " +
      "JOIN products p ON oi.product_id = p.id " +
      "WHERE oi.order_id = $1",
      [id]
    );

    order.items = itemsResult.rows;

    res.json(order);
  } catch (err) {
    next(err);
  }
};


// Atualizar status do pedido
export const updateOrder = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const result = await pool.query(
      "UPDATE orders SET status=$1 WHERE id=$2 RETURNING *",
      [status, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Pedido não encontrado" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
};

// Deletar pedido
export const deleteOrder = async (req, res, next) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM orders WHERE id=$1 RETURNING id", [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Pedido não encontrado" });
    }

    res.json({ message: "Pedido deletado com sucesso" });
  } catch (err) {
    next(err);
  }
};
