import pool from "../config/db.js";

// ── Categorias ────────────────────────────────────────────────────────────────
export const getAllCategories = async () => {
  const res = await pool.query(
    `SELECT id, name, type FROM transaction_categories ORDER BY type, name`
  );
  return res.rows;
};

// ── Lançamentos ───────────────────────────────────────────────────────────────
export const getAllTransactions = async (filters = {}) => {
  const conditions = ["1=1"];
  const params = [];
  let i = 1;

  if (filters.type)   { conditions.push(`t.type = $${i++}`);   params.push(filters.type); }
  if (filters.status) { conditions.push(`t.status = $${i++}`); params.push(filters.status); }
  if (filters.from)   { conditions.push(`t.due_date >= $${i++}`); params.push(filters.from); }
  if (filters.to)     { conditions.push(`t.due_date <= $${i++}`); params.push(filters.to); }

  const res = await pool.query(
    `SELECT
       t.*,
       tc.name  AS category_name,
       c.name   AS client_name,
       s.name   AS supplier_name
     FROM transactions t
     LEFT JOIN transaction_categories tc ON tc.id = t.category_id
     LEFT JOIN clients  c ON c.id = t.client_id
     LEFT JOIN suppliers s ON s.id = t.supplier_id
     WHERE ${conditions.join(" AND ")}
     ORDER BY t.due_date DESC, t.created_at DESC`,
    params
  );
  return res.rows;
};

export const getTransactionById = async (id) => {
  const res = await pool.query(
    `SELECT t.*, tc.name AS category_name
     FROM transactions t
     LEFT JOIN transaction_categories tc ON tc.id = t.category_id
     WHERE t.id = $1`,
    [id]
  );
  return res.rows[0];
};

export const createTransaction = async (data) => {
  const {
    type, description, amount, due_date, paid_date,
    status = "pendente", category_id, order_id,
    client_id, supplier_id, user_id, notes,
  } = data;

  const res = await pool.query(
    `INSERT INTO transactions
       (type, description, amount, due_date, paid_date, status,
        category_id, order_id, client_id, supplier_id, user_id, notes)
     VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)
     RETURNING *`,
    [
      type, description, amount, due_date,
      paid_date || null, status,
      category_id || null, order_id || null,
      client_id || null, supplier_id || null,
      user_id || null, notes || null,
    ]
  );
  return res.rows[0];
};

export const updateTransaction = async (id, data) => {
  const {
    type, description, amount, due_date, paid_date,
    status, category_id, notes,
  } = data;

  const res = await pool.query(
    `UPDATE transactions SET
       type        = COALESCE($1, type),
       description = COALESCE($2, description),
       amount      = COALESCE($3, amount),
       due_date    = COALESCE($4, due_date),
       paid_date   = $5,
       status      = COALESCE($6, status),
       category_id = COALESCE($7, category_id),
       notes       = COALESCE($8, notes),
       updated_at  = NOW()
     WHERE id = $9
     RETURNING *`,
    [type, description, amount, due_date, paid_date || null, status, category_id || null, notes, id]
  );
  return res.rows[0];
};

export const deleteTransaction = async (id) => {
  const res = await pool.query(
    `DELETE FROM transactions WHERE id = $1 RETURNING id`,
    [id]
  );
  return res.rows[0];
};

// ── Fluxo de caixa por período ────────────────────────────────────────────────
export const getCashFlow = async (from, to) => {
  // Totais gerais
  const totalsRes = await pool.query(
    `SELECT
       type,
       SUM(amount) AS total
     FROM transactions
     WHERE status = 'pago'
       AND paid_date BETWEEN $1 AND $2
     GROUP BY type`,
    [from, to]
  );

  // Por mês
  const byMonthRes = await pool.query(
    `SELECT
       TO_CHAR(DATE_TRUNC('month', paid_date), 'YYYY-MM') AS month,
       TO_CHAR(DATE_TRUNC('month', paid_date), 'Mon/YY')  AS label,
       type,
       SUM(amount) AS total
     FROM transactions
     WHERE status = 'pago'
       AND paid_date BETWEEN $1 AND $2
     GROUP BY DATE_TRUNC('month', paid_date), type
     ORDER BY DATE_TRUNC('month', paid_date)`,
    [from, to]
  );

  // Pendentes e vencidas
  const pendingRes = await pool.query(
    `SELECT
       type,
       COUNT(*) AS count,
       SUM(amount) AS total
     FROM transactions
     WHERE status IN ('pendente','vencido')
     GROUP BY type`
  );

  return {
    totals:  totalsRes.rows,
    byMonth: byMonthRes.rows,
    pending: pendingRes.rows,
  };
};

// ── Criar conta a receber a partir de um pedido ───────────────────────────────
export const createReceivableFromOrder = async (order, userId) => {
  // Evita duplicata — verifica se já existe lançamento para esse pedido
  const existing = await pool.query(
    `SELECT id FROM transactions WHERE order_id = $1 AND type = 'receita'`,
    [order.id]
  );
  if (existing.rows.length > 0) return existing.rows[0];

  // Busca categoria padrão "Venda de produto"
  const catRes = await pool.query(
    `SELECT id FROM transaction_categories WHERE name = 'Venda de produto' LIMIT 1`
  );
  const categoryId = catRes.rows[0]?.id || null;

  const res = await pool.query(
    `INSERT INTO transactions
       (type, description, amount, due_date, paid_date, status,
        category_id, order_id, client_id, user_id)
     VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)
     RETURNING *`,
    [
      "receita",
      `Pedido #${order.id} — ${order.client_name ?? "cliente"}`,
      order.total,
      new Date().toISOString().split("T")[0],   // vence hoje (já pago)
      new Date().toISOString().split("T")[0],   // pago hoje
      "pago",
      categoryId,
      order.id,
      order.client_id,
      userId,
    ]
  );
  return res.rows[0];
};
