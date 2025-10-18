import pool from "../config/db.js";

// Controller para retornar o resumo do dashboard
export const getSummary = async (req, res, next) => {
  const { from, to } = req.query; // filtro opcional de datas

  try {
    // Filtro de data
    const dateFilter = from && to ? `WHERE created_at BETWEEN '${from}' AND '${to}'` : "";

    // Total de pedidos
    const ordersRes = await pool.query(`SELECT COUNT(*) AS totalOrders, SUM(total_amount) AS totalRevenue FROM orders ${dateFilter}`);
    const totalOrders = Number(ordersRes.rows[0].totalorders) || 0;
    const totalRevenue = Number(ordersRes.rows[0].totalrevenue) || 0;

    // Total de clientes
    const clientsRes = await pool.query(`SELECT COUNT(*) AS totalClients FROM clients`);
    const totalClients = Number(clientsRes.rows[0].totalclients) || 0;

    // Produtos em estoque
    const productsRes = await pool.query(`SELECT name, stock FROM products`);
    const productsStock = productsRes.rows;

    // Pedidos por status
    const ordersByStatusRes = await pool.query(`SELECT status, COUNT(*) AS count FROM orders ${dateFilter} GROUP BY status`);
    const ordersByStatus = ordersByStatusRes.rows.map(row => ({
      status: row.status,
      count: Number(row.count),
    }));

    // Pedidos por cliente
    const ordersByClientRes = await pool.query(`
      SELECT c.name AS client_name, COUNT(o.id) AS total_orders
      FROM clients c
      LEFT JOIN orders o ON c.id = o.client_id
      ${from && to ? `AND o.created_at BETWEEN '${from}' AND '${to}'` : ""}
      GROUP BY c.id, c.name
    `);
    const ordersPerClient = ordersByClientRes.rows.map(row => ({
      client_name: row.client_name,
      total_orders: Number(row.total_orders),
    }));

    res.json({
      totalOrders,
      totalClients,
      totalRevenue,
      productsStock,
      ordersByStatus,
      ordersPerClient,
    });
  } catch (err) {
    next(err);
  }
};
