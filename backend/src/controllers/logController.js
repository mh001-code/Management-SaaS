import pool from "../config/db.js";

// GET /api/logs?userId=1&route=/api/orders&startDate=2025-09-01&endDate=2025-09-18
export const getLogs = async (req, res, next) => {
  try {
    const { userId, route, startDate, endDate } = req.query;

    let query = `SELECT * FROM logs WHERE 1=1`;
    const params = [];
    let count = 1;

    if (userId) {
      query += ` AND user_id = $${count}`;
      params.push(userId);
      count++;
    }
    if (route) {
      query += ` AND route = $${count}`;
      params.push(route);
      count++;
    }
    if (startDate) {
      query += ` AND created_at >= $${count}`;
      params.push(startDate);
      count++;
    }
    if (endDate) {
      query += ` AND created_at <= $${count}`;
      params.push(endDate);
      count++;
    }

    query += ` ORDER BY created_at DESC`;

    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
};
