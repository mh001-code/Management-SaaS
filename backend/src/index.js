import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import pool from "./config/db.js";
import userRoutes from "./routes/userRoutes.js";
import authRoutes from "./routes/authRoutes.js";
import authMiddleware from "./middlewares/authMiddleware.js";
import errorHandler from "./middlewares/errorHandler.js";
import productRoutes from "./routes/productRoutes.js";
import clientsRoutes from "./routes/clientsRoutes.js";
import ordersRoutes from "./routes/ordersRoutes.js";
import morgan from "morgan";
import { swaggerDocs } from "./docs.js";
import reportsRoutes from "./routes/reportsRoutes.js";
import logMiddleware from "./middlewares/logMiddleware.js";
import logRoutes from "./routes/logRoutes.js";
import summaryRoutes from "./routes/summaryRoutes.js";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(morgan("dev"));
app.use(cors());
app.use(express.json());

// Cache desabilitado para todas as rotas da API
app.use("/api", (req, res, next) => {
  res.set("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate");
  res.set("Pragma", "no-cache");
  res.set("Expires", "0");
  next();
});

// Testar conexão com o banco
pool.query("SELECT NOW()", (err, res) => {
  if (err) console.error("Erro ao conectar no banco:", err);
  else console.log("Conectado ao banco! Hora atual:", res.rows[0].now);
});

// Swagger
swaggerDocs(app);

// Log de todas as requisições
app.use(logMiddleware);

// ─── Rotas públicas ───────────────────────────────────────────────────────────
app.use("/api/auth", authRoutes);

// ─── Rotas protegidas ─────────────────────────────────────────────────────────
// ✅ authMiddleware aplicado apenas aqui — removido dos arquivos de rota internos
app.use("/api/summary", authMiddleware, summaryRoutes);
app.use("/api/reports", authMiddleware, reportsRoutes);
app.use("/api/logs", authMiddleware, logRoutes);
app.use("/api/users", authMiddleware, userRoutes);
app.use("/api/products", authMiddleware, productRoutes);
app.use("/api/clients", authMiddleware, clientsRoutes);
app.use("/api/orders", authMiddleware, ordersRoutes);

// Rota de teste
app.get("/", (req, res) => res.send("API rodando 🚀"));

// Middleware de erros (deve ser o último)
app.use(errorHandler);

app.listen(PORT, () => console.log(`Servidor rodando na porta ${PORT}`));