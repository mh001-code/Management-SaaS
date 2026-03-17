import pool from "../config/db.js";

export const getSummary = async (req, res, next) => {
  const { from, to } = req.query;

  // ✅ Validação básica do formato de data antes de usar nas queries
  const isValidDate = (d) => d && /^\d{4}-\d{2}-\d{2}$/.test(d);
  const useDateFilter = isValidDate(from) && isValidDate(to);

  try {
    // ─── Total de pedidos e receita ──────────────────────────────
    let ordersQuery, ordersParams;

    if (useDateFilter) {
      ordersQuery = `
        SELECT COUNT(*) AS total_orders, COALESCE(SUM(total), 0) AS total_sales
        FROM orders
        WHERE created_at BETWEEN $1 AND $2
      `;
      ordersParams = [from, to];
    } else {
      ordersQuery = `
        SELECT COUNT(*) AS total_orders, COALESCE(SUM(total), 0) AS total_sales
        FROM orders
      `;
      ordersParams = [];
    }

    const ordersRes = await pool.query(ordersQuery, ordersParams);
    const totalOrders = Number(ordersRes.rows[0]?.total_orders) || 0;
    const totalSales = Number(ordersRes.rows[0]?.total_sales || 0).toFixed(2);

    // ─── Total de clientes ───────────────────────────────────────
    const clientsRes = await pool.query(
      `SELECT COUNT(*) AS total_clients FROM clients`
    );
    const totalClients = Number(clientsRes.rows[0]?.total_clients) || 0;

    // ─── Top 5 produtos mais vendidos ────────────────────────────
    const topProductsRes = await pool.query(`
      SELECT p.name AS product, COALESCE(SUM(oi.quantity), 0) AS sold
      FROM products p
      LEFT JOIN order_items oi ON p.id = oi.product_id
      GROUP BY p.id, p.name
      ORDER BY sold DESC
      LIMIT 5
    `);
    const topProducts = topProductsRes.rows.map((row) => ({
      product: row.product,
      sold: Number(row.sold),
    }));

    // ─── Pedidos por status ───────────────────────────────────────
    let statusQuery, statusParams;

    if (useDateFilter) {
      statusQuery = `
        SELECT status, COUNT(*) AS count
        FROM orders
        WHERE created_at BETWEEN $1 AND $2
        GROUP BY status
      `;
      statusParams = [from, to];
    } else {
      statusQuery = `
        SELECT status, COUNT(*) AS count
        FROM orders
        GROUP BY status
      `;
      statusParams = [];
    }

    const ordersByStatusRes = await pool.query(statusQuery, statusParams);
    const ordersByStatus = ordersByStatusRes.rows.map((row) => ({
      status: row.status,
      count: Number(row.count),
    }));

    // ─── Top clientes por número de pedidos ──────────────────────
    let clientsQueryStr, clientsParams;

    if (useDateFilter) {
      clientsQueryStr = `
        SELECT c.name AS client, COUNT(o.id) AS orders
        FROM clients c
        LEFT JOIN orders o ON c.id = o.client_id
          AND o.created_at BETWEEN $1 AND $2
        GROUP BY c.id, c.name
        ORDER BY orders DESC
        LIMIT 10
      `;
      clientsParams = [from, to];
    } else {
      clientsQueryStr = `
        SELECT c.name AS client, COUNT(o.id) AS orders
        FROM clients c
        LEFT JOIN orders o ON c.id = o.client_id
        GROUP BY c.id, c.name
        ORDER BY orders DESC
        LIMIT 10
      `;
      clientsParams = [];
    }

    const topClientsRes = await pool.query(clientsQueryStr, clientsParams);
    const ordersPerClient = topClientsRes.rows.map((row) => ({
      client: row.client,
      orders: Number(row.orders),
    }));

    // ─── Resposta ─────────────────────────────────────────────────
    res.json({
      totalOrders,
      totalClients,
      totalSales,
      topProducts,
      ordersByStatus,
      ordersPerClient,
    });
  } catch (err) {
    console.error("❌ getSummary ERROR:", err.message);
    next(err);
  }
};