import pool from "../config/db.js";

// Transação
let clientTransaction = null;

// Inicia a transação e retorna o client
export const beginTransaction = async () => {
  clientTransaction = await pool.connect();
  await clientTransaction.query("BEGIN");
  return clientTransaction;
};

// Commit da transação
export const commitTransaction = async () => {
  if (clientTransaction) {
    await clientTransaction.query("COMMIT");
    clientTransaction.release();
    clientTransaction = null;
  }
};

// Rollback da transação
export const rollbackTransaction = async () => {
  if (clientTransaction) {
    await clientTransaction.query("ROLLBACK");
    clientTransaction.release();
    clientTransaction = null;
  }
};

// Criar pedido dentro da transação
export const createOrder = async (client_id, user_id, total) => {
  if (!clientTransaction) throw new Error("Transação não iniciada");

  const res = await clientTransaction.query(
    `INSERT INTO orders (client_id, user_id, total, created_at)
     VALUES ($1, $2, $3, NOW()) RETURNING *`,
    [client_id, user_id, total]
  );
  return res.rows[0];
};

// Listar todos pedidos (não precisa de transação)
// Buscar todos os pedidos com cliente e itens
export const getAllOrdersWithDetails = async () => {
  const res = await pool.query(`
    SELECT 
      o.id AS order_id,
      o.status,
      o.total,
      o.created_at,
      c.id AS client_id,
      c.name AS client_name,
      json_agg(
        json_build_object(
          'product_id', p.id,
          'product_name', p.name,
          'quantity', oi.quantity,
          'price', oi.price
        )
      ) AS items
    FROM orders o
    JOIN clients c ON o.client_id = c.id
    JOIN order_items oi ON oi.order_id = o.id
    JOIN products p ON oi.product_id = p.id
    GROUP BY o.id, c.id
    ORDER BY o.id
  `);

  return res.rows;
};

// Buscar pedido por ID (não precisa de transação)
export const getOrderById = async (id) => {
  const res = await pool.query(`SELECT * FROM orders WHERE id=$1`, [id]);
  return res.rows[0];
};

// Atualizar status do pedido (não precisa de transação)
export const updateOrderStatus = async (id, status) => {
  const res = await pool.query(
    `UPDATE orders SET status=$1 WHERE id=$2 RETURNING *`,
    [status, id]
  );
  return res.rows[0];
};

// Deletar pedido (não precisa de transação)
export const deleteOrder = async (id) => {
  const res = await pool.query(`DELETE FROM orders WHERE id=$1 RETURNING *`, [id]);
  return res.rows[0];
};