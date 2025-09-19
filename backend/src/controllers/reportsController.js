import pool from "../config/db.js";

export const getSummaryReport = async (req, res, next) => {
  try {
    const { startDate, endDate, status } = req.query;

    // -------------------------------
    // 1️⃣ Total de produtos e estoque
    // -------------------------------
    const productsStockQuery = `
      SELECT p.id, p.name, COALESCE(s.quantity, 0) AS stock
      FROM products p
      LEFT JOIN stock s ON s.product_id = p.id
      ORDER BY p.id
    `;
    const productsStockResult = await pool.query(productsStockQuery);
    const productsStock = productsStockResult.rows;

    // -------------------------------------------
    // 2️⃣ Total de pedidos por cliente (filtros)
    // -------------------------------------------
    let values = [];
    let conditions = "";

    if (status) {
      values.push(status);
      conditions += ` AND o.status = $${values.length}`;
    }
    if (startDate) {
      values.push(startDate);
      conditions += ` AND o.created_at >= $${values.length}`;
    }
    if (endDate) {
      values.push(endDate);
      conditions += ` AND o.created_at <= $${values.length}`;
    }

    const ordersPerClientQuery = `
      SELECT 
        c.id AS client_id, 
        c.name AS client_name, 
        COALESCE(COUNT(o.id), 0) AS total_orders
      FROM clients c
      LEFT JOIN orders o ON o.client_id = c.id
      WHERE 1=1
      ${conditions}
      GROUP BY c.id, c.name
      ORDER BY total_orders DESC
    `;
    const ordersPerClientResult = await pool.query(ordersPerClientQuery, values);
    const ordersPerClient = ordersPerClientResult.rows;

    // -------------------------------
    // 3️⃣ Total faturado (total revenue)
    // -------------------------------
    values = [];
    conditions = "";

    if (status) {
      values.push(status);
      conditions += ` AND o.status = $${values.length}`;
    }
    if (startDate) {
      values.push(startDate);
      conditions += ` AND o.created_at >= $${values.length}`;
    }
    if (endDate) {
      values.push(endDate);
      conditions += ` AND o.created_at <= $${values.length}`;
    }

    const totalRevenueQuery = `
      SELECT COALESCE(SUM(oi.quantity * p.price), 0) AS total_revenue
      FROM orders o
      JOIN order_items oi ON oi.order_id = o.id
      JOIN products p ON p.id = oi.product_id
      WHERE 1=1
      ${conditions}
    `;
    const totalRevenueResult = await pool.query(totalRevenueQuery, values);
    const totalRevenue = totalRevenueResult.rows[0].total_revenue;

    // -------------------------------
    // 4️⃣ Pedidos por status
    // -------------------------------
    values = [];
    conditions = "";

    if (startDate) {
      values.push(startDate);
      conditions += ` AND created_at >= $${values.length}`;
    }
    if (endDate) {
      values.push(endDate);
      conditions += ` AND created_at <= $${values.length}`;
    }

    const ordersByStatusQuery = `
      SELECT status, COUNT(*) AS count
      FROM orders
      WHERE 1=1
      ${conditions}
      GROUP BY status
    `;
    const ordersByStatusResult = await pool.query(ordersByStatusQuery, values);
    const ordersByStatus = ordersByStatusResult.rows;

    // -------------------------------
    // Resposta final
    // -------------------------------
    res.json({
      productsStock,
      ordersPerClient,
      totalRevenue,
      ordersByStatus,
    });
  } catch (err) {
    next(err);
  }
};
