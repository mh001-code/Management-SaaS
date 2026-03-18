import pool from "../config/db.js";

export const getSummary = async (req, res, next) => {
  const { from, to } = req.query;

  const isValidDate = (d) => d && /^\d{4}-\d{2}-\d{2}$/.test(d);
  const useDateFilter = isValidDate(from) && isValidDate(to);

  try {
    // ─── 1. Total de pedidos e receita ────────────────────────────────────────
    const ordersQuery = useDateFilter
      ? `SELECT COUNT(*) AS total_orders, COALESCE(SUM(total), 0) AS total_sales
         FROM orders WHERE created_at BETWEEN $1 AND $2`
      : `SELECT COUNT(*) AS total_orders, COALESCE(SUM(total), 0) AS total_sales
         FROM orders`;
    const ordersParams = useDateFilter ? [from, to] : [];
    const ordersRes = await pool.query(ordersQuery, ordersParams);
    const totalOrders = Number(ordersRes.rows[0]?.total_orders) || 0;
    const totalSales  = Number(ordersRes.rows[0]?.total_sales  || 0).toFixed(2);

    // ─── 2. Ticket médio ──────────────────────────────────────────────────────
    const avgTicket = totalOrders > 0
      ? (Number(totalSales) / totalOrders).toFixed(2)
      : "0.00";

    // ─── 3. Total de clientes ─────────────────────────────────────────────────
    const clientsRes = await pool.query(
      `SELECT COUNT(*) AS total_clients FROM clients`
    );
    const totalClients = Number(clientsRes.rows[0]?.total_clients) || 0;

    // ─── 4. Top 5 produtos mais vendidos ──────────────────────────────────────
    const topProductsRes = await pool.query(`
      SELECT p.name AS product, COALESCE(SUM(oi.quantity), 0) AS sold
      FROM products p
      LEFT JOIN order_items oi ON p.id = oi.product_id
      GROUP BY p.id, p.name
      ORDER BY sold DESC
      LIMIT 5
    `);
    const topProducts = topProductsRes.rows.map((r) => ({
      product: r.product,
      sold: Number(r.sold),
    }));

    // ─── 5. Pedidos por status ────────────────────────────────────────────────
    const statusQuery = useDateFilter
      ? `SELECT status, COUNT(*) AS count FROM orders
         WHERE created_at BETWEEN $1 AND $2 GROUP BY status`
      : `SELECT status, COUNT(*) AS count FROM orders GROUP BY status`;
    const statusParams = useDateFilter ? [from, to] : [];
    const ordersByStatusRes = await pool.query(statusQuery, statusParams);
    const ordersByStatus = ordersByStatusRes.rows.map((r) => ({
      status: r.status,
      count: Number(r.count),
    }));

    // ─── 6. Top clientes por número de pedidos ────────────────────────────────
    const clientsQuery = useDateFilter
      ? `SELECT c.name AS client, COUNT(o.id) AS orders
         FROM clients c
         LEFT JOIN orders o ON c.id = o.client_id
           AND o.created_at BETWEEN $1 AND $2
         GROUP BY c.id, c.name
         ORDER BY orders DESC LIMIT 10`
      : `SELECT c.name AS client, COUNT(o.id) AS orders
         FROM clients c
         LEFT JOIN orders o ON c.id = o.client_id
         GROUP BY c.id, c.name
         ORDER BY orders DESC LIMIT 10`;
    const clientsParams = useDateFilter ? [from, to] : [];
    const topClientsRes = await pool.query(clientsQuery, clientsParams);
    const ordersPerClient = topClientsRes.rows.map((r) => ({
      client: r.client,
      orders: Number(r.orders),
    }));

    // ─── 7. Receita por mês (últimos 6 meses) ────────────────────────────────
    const revenueByMonthRes = await pool.query(`
      SELECT
        TO_CHAR(DATE_TRUNC('month', created_at), 'YYYY-MM') AS month,
        TO_CHAR(DATE_TRUNC('month', created_at), 'Mon/YY')  AS label,
        COALESCE(SUM(total), 0) AS revenue,
        COUNT(*) AS orders
      FROM orders
      WHERE created_at >= DATE_TRUNC('month', NOW()) - INTERVAL '5 months'
      GROUP BY DATE_TRUNC('month', created_at)
      ORDER BY DATE_TRUNC('month', created_at)
    `);
    const revenueByMonth = revenueByMonthRes.rows.map((r) => ({
      month:   r.month,
      label:   r.label,
      revenue: Number(r.revenue),
      orders:  Number(r.orders),
    }));

    // ─── 8. Pedidos recentes (últimos 8) ──────────────────────────────────────
    const recentOrdersRes = await pool.query(`
      SELECT
        o.id,
        c.name AS client_name,
        o.total,
        o.status,
        o.created_at
      FROM orders o
      JOIN clients c ON o.client_id = c.id
      ORDER BY o.created_at DESC
      LIMIT 8
    `);
    const recentOrders = recentOrdersRes.rows.map((r) => ({
      id:          r.id,
      client_name: r.client_name,
      total:       Number(r.total),
      status:      r.status,
      created_at:  r.created_at,
    }));

    // ─── 9. Produtos com estoque baixo (≤ 5 unidades) ────────────────────────
    const lowStockRes = await pool.query(`
      SELECT p.id, p.name, COALESCE(s.quantity, 0) AS quantity
      FROM products p
      LEFT JOIN stock s ON s.product_id = p.id
      WHERE COALESCE(s.quantity, 0) <= 5
      ORDER BY COALESCE(s.quantity, 0) ASC
      LIMIT 10
    `);
    const lowStock = lowStockRes.rows.map((r) => ({
      id:       r.id,
      name:     r.name,
      quantity: Number(r.quantity),
    }));

    // ─── Resposta ─────────────────────────────────────────────────────────────
    res.json({
      totalOrders,
      totalClients,
      totalSales,
      avgTicket,
      topProducts,
      ordersByStatus,
      ordersPerClient,
      revenueByMonth,
      recentOrders,
      lowStock,
    });
  } catch (err) {
    console.error("❌ getSummary ERROR:", err.message);
    next(err);
  }
};
