import pool from "../config/db.js";

const logMiddleware = async (req, res, next) => {
  const start = Date.now();

  // Captura quando a resposta terminar
  res.on("finish", async () => {
    const duration = Date.now() - start;
    const userId = req.user?.userId || null; // do authMiddleware, se houver
    const { method, originalUrl } = req;
    const status = res.statusCode;

    try {
      await pool.query(
        `INSERT INTO logs (user_id, route, method, status) VALUES ($1, $2, $3, $4)`,
        [userId, originalUrl, method, status]
      );
      console.log(
        `[LOG] User: ${userId || "Anônimo"} | ${method} ${originalUrl} | Status: ${status} | ${duration}ms`
      );
    } catch (err) {
      console.error("Erro ao registrar log:", err);
    }
  });

  next();
};

export default logMiddleware;
