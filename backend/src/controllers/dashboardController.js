import pool from "../config/db.js";

// Função para buscar resumo do dashboard
export const getSummary = async (req, res, next) => {
  try {
    // Total de vendas
    const totalSalesRes = await pool.query("SELECT SUM(total) AS total_sales FROM orders");
    const totalSales = totalSalesRes.rows[0].total_sales || 0;

    // Pedidos por cliente
    const ordersPerClientRes = await pool.query(`
      SELECT c.name AS client, COUNT(o.id) AS orders
      FROM clients c
      LEFT JOIN orders o ON o.client_id = c.id
      GROUP BY c.name
      ORDER BY orders DESC
    `);
    const ordersPerClient = ordersPerClientRes.rows;

    // Produtos mais vendidos
    const topProductsRes = await pool.query(`
      SELECT p.name AS product, SUM(oi.quantity) AS sold
      FROM order_items oi
      JOIN products p ON oi.product_id = p.id
      GROUP BY p.name
      ORDER BY sold DESC
      LIMIT 5
    `);
    const topProducts = topProductsRes.rows;

    res.json({ totalSales, ordersPerClient, topProducts });
  } catch (err) {
    next(err);
  }
};
