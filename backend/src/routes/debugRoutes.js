import { Router } from "express";
import pool from "../config/db.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = Router();

// Rota de debug - retorna dados brutos do database (não mais usada)
router.get("/summary", authMiddleware, async (req, res, next) => {
  try {
    // Query 1: Total de pedidos
    const q1 = await pool.query("SELECT COUNT(*) AS total_orders, COALESCE(SUM(total), 0) AS total_sales FROM orders");
    
    // Query 2: Total de clientes
    const q2 = await pool.query("SELECT COUNT(*) AS total_clients FROM clients");
    
    // Query 3: Pedidos por status
    const q3 = await pool.query("SELECT status, COUNT(*) AS count FROM orders GROUP BY status");
    
    // Query 4: Top Clientes
    const q4 = await pool.query("SELECT c.name as client, COUNT(o.id) as orders FROM clients c LEFT JOIN orders o ON c.id = o.client_id GROUP BY c.id, c.name ORDER BY orders DESC LIMIT 10");
    
    const debugResponse = {
      query1_totalOrders: q1.rows[0]?.total_orders,
      query1_totalSales: q1.rows[0]?.total_sales,
      query2_totalClients: q2.rows[0]?.total_clients,
      query3_ordersByStatus: q3.rows.map(r => ({ status: r.status, count: Number(r.count) })),
      query4_ordersPerClient: q4.rows,
      timestamp: new Date().toISOString()
    };
    
    res.json(debugResponse);
  } catch (err) {
    next(err);
  }
});

export default router;
