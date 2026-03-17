import pool from "../config/db.js";

// ─── Transação ────────────────────────────────────────────────────────────────
// ✅ Retorna o client para que o controller gerencie o ciclo de vida
export const beginTransaction = async () => {
  const client = await pool.connect();
  await client.query("BEGIN");
  return client;
};

export const commitTransaction = async (client) => {
  await client.query("COMMIT");
  client.release();
};

export const rollbackTransaction = async (client) => {
  await client.query("ROLLBACK");
  client.release();
};

// ─── Queries ──────────────────────────────────────────────────────────────────

// ✅ client é passado como parâmetro — sem estado global
export const createOrder = async (client, clientId, userId, total, status = "pendente") => {
  const res = await client.query(
    `INSERT INTO orders (client_id, user_id, total, status, created_at)
     VALUES ($1, $2, $3, $4, NOW()) RETURNING *`,
    [clientId, userId, total, status]
  );
  return res.rows[0];
};

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

export const getOrderById = async (id) => {
  const res = await pool.query(`SELECT * FROM orders WHERE id = $1`, [id]);
  return res.rows[0];
};

export const updateOrderStatus = async (id, status) => {
  const res = await pool.query(
    `UPDATE orders
     SET status = $1, updated_at = NOW()
     WHERE id = $2
     RETURNING *`,
    [status, id]
  );
  return res.rows[0];
};

// ✅ client como parâmetro
export const updateOrderClientTotalStatus = async (client, orderId, clientId, total, status) => {
  const executor = client || pool;
  const res = await executor.query(
    `UPDATE orders
     SET client_id = $1, total = $2, status = $3, updated_at = NOW()
     WHERE id = $4
     RETURNING *`,
    [clientId, total, status, orderId]
  );
  return res.rows[0];
};

export const deleteOrder = async (id) => {
  const res = await pool.query(
    `DELETE FROM orders WHERE id = $1 RETURNING *`,
    [id]
  );
  return res.rows[0];
};