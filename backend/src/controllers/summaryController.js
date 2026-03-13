import pool from "../config/db.js";

// Controller para retornar o resumo do dashboard
export const getSummary = async (req, res, next) => {
  const { from, to } = req.query; // filtro opcional de datas

  try {
    // Filtro de data
    const dateFilter = from && to ? `WHERE created_at BETWEEN '${from}' AND '${to}'` : "";

    // Total de pedidos e receita
    const ordersRes = await pool.query(`SELECT COUNT(*) AS total_orders, COALESCE(SUM(total), 0) AS total_sales FROM orders ${dateFilter}`);
    const totalOrders = Number(ordersRes.rows[0]?.total_orders) || 0;
    const totalSales = (ordersRes.rows[0]?.total_sales || 0).toFixed(2);

    // Total de clientes
    const clientsRes = await pool.query(`SELECT COUNT(*) AS total_clients FROM clients`);
    const totalClients = Number(clientsRes.rows[0]?.total_clients) || 0;

    // Top 5 Produtos mais vendidos
    const topProductsRes = await pool.query(`
      SELECT p.name as product, COALESCE(SUM(oi.quantity), 0) as sold
      FROM products p
      LEFT JOIN order_items oi ON p.id = oi.product_id
      GROUP BY p.id, p.name
      ORDER BY sold DESC
      LIMIT 5
    `);
    const topProducts = topProductsRes.rows;

    // Pedidos por status
    const ordersByStatusRes = await pool.query(`SELECT status, COUNT(*) AS count FROM orders ${dateFilter} GROUP BY status`);
    const ordersByStatus = ordersByStatusRes.rows.map(row => ({
      status: row.status,
      count: Number(row.count),
    }));

    // Top Clientes por número de pedidos
    const topClientsRes = await pool.query(`
      SELECT c.name as client, COUNT(o.id) as orders
      FROM clients c
      LEFT JOIN orders o ON c.id = o.client_id
      ${from && to ? `WHERE o.created_at BETWEEN '${from}' AND '${to}'` : ""}
      GROUP BY c.id, c.name
      ORDER BY orders DESC
      LIMIT 10
    `);
    const ordersPerClient = topClientsRes.rows;

    res.json({
      totalOrders,
      totalClients,
      totalSales,
      topProducts,
      ordersByStatus,
      ordersPerClient,
    });
  } catch (err) {
    next(err);
  }
};
