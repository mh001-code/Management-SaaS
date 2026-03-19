import pool from "../config/db.js";

const exec = (client) => client || pool;

// ── Transação (reutiliza helpers do OrderModel) ────────────────────────────────
export const beginTransaction = async () => {
  const client = await pool.connect();
  await client.query("BEGIN");
  return client;
};
export const commitTransaction   = async (c) => { await c.query("COMMIT");   c.release(); };
export const rollbackTransaction = async (c) => { await c.query("ROLLBACK"); c.release(); };

// ── Ordens ────────────────────────────────────────────────────────────────────
export const getAllPurchaseOrders = async () => {
  const res = await pool.query(
    `SELECT
       po.id, po.status, po.total, po.notes, po.created_at,
       s.id   AS supplier_id,
       s.name AS supplier_name,
       json_agg(
         json_build_object(
           'product_id',   p.id,
           'product_name', p.name,
           'quantity',     poi.quantity,
           'unit_cost',    poi.unit_cost
         )
       ) AS items
     FROM purchase_orders po
     JOIN suppliers s     ON po.supplier_id = s.id
     JOIN purchase_order_items poi ON poi.purchase_order_id = po.id
     JOIN products p      ON poi.product_id = p.id
     GROUP BY po.id, s.id
     ORDER BY po.id DESC`
  );
  return res.rows;
};

export const getPurchaseOrderById = async (id) => {
  const res = await pool.query(
    `SELECT po.*, s.name AS supplier_name
     FROM purchase_orders po
     JOIN suppliers s ON po.supplier_id = s.id
     WHERE po.id = $1`,
    [id]
  );
  return res.rows[0];
};

export const createPurchaseOrder = async (client, supplierId, userId, total, status, notes) => {
  const res = await exec(client).query(
    `INSERT INTO purchase_orders (supplier_id, user_id, total, status, notes)
     VALUES ($1, $2, $3, $4, $5) RETURNING *`,
    [supplierId, userId, total, status, notes || null]
  );
  return res.rows[0];
};

export const createPurchaseOrderItem = async (client, orderId, productId, quantity, unitCost) => {
  const res = await exec(client).query(
    `INSERT INTO purchase_order_items (purchase_order_id, product_id, quantity, unit_cost)
     VALUES ($1, $2, $3, $4) RETURNING *`,
    [orderId, productId, quantity, unitCost]
  );
  return res.rows[0];
};

export const updatePurchaseOrderStatus = async (id, status) => {
  const res = await pool.query(
    `UPDATE purchase_orders
     SET status = $1, updated_at = NOW()
     WHERE id = $2 RETURNING *`,
    [status, id]
  );
  return res.rows[0];
};

export const deletePurchaseOrder = async (id) => {
  const res = await pool.query(
    `DELETE FROM purchase_orders WHERE id = $1 RETURNING id`,
    [id]
  );
  return res.rows[0];
};

// Ao receber uma ordem, incrementa estoque dos produtos
export const receivePurchaseOrder = async (orderId) => {
  const client = await beginTransaction();
  try {
    // 1. Busca dados da ordem + fornecedor para o lançamento
    const orderRes = await client.query(
      `SELECT po.total, po.supplier_id, po.notes, s.name AS supplier_name
       FROM purchase_orders po
       JOIN suppliers s ON s.id = po.supplier_id
       WHERE po.id = $1`,
      [orderId]
    );
    const order = orderRes.rows[0];

    // 2. Incrementa estoque de cada item
    const itemsRes = await client.query(
      `SELECT product_id, quantity FROM purchase_order_items
       WHERE purchase_order_id = $1`,
      [orderId]
    );
    for (const item of itemsRes.rows) {
      await client.query(
        `UPDATE stock
         SET quantity = quantity + $1, last_updated = NOW()
         WHERE product_id = $2`,
        [item.quantity, item.product_id]
      );
    }

    // 3. Marca a ordem como recebida
    await client.query(
      `UPDATE purchase_orders SET status = 'recebido', updated_at = NOW() WHERE id = $1`,
      [orderId]
    );

    // 4. Cria lançamento de despesa no financeiro (se ainda não existir)
    const alreadyExists = await client.query(
      `SELECT id FROM transactions WHERE description = $1 LIMIT 1`,
      [`Compra #${orderId} — ${order.supplier_name}`]
    );

    if (alreadyExists.rows.length === 0) {
      // Busca categoria "Fornecedor" (criada pela migration 004)
      const catRes = await client.query(
        `SELECT id FROM transaction_categories WHERE name = 'Fornecedor' LIMIT 1`
      );
      const categoryId = catRes.rows[0]?.id ?? null;

      await client.query(
        `INSERT INTO transactions
           (type, description, amount, due_date, status, category_id, supplier_id, notes)
         VALUES
           ('despesa', $1, $2, CURRENT_DATE, 'pendente', $3, $4, $5)`,
        [
          `Compra #${orderId} — ${order.supplier_name}`,
          order.total,
          categoryId,
          order.supplier_id,
          order.notes || null,
        ]
      );
    }

    await commitTransaction(client);
  } catch (err) {
    await rollbackTransaction(client);
    throw err;
  }
};