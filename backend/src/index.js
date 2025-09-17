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
import stockRoutes from "./routes/stockRoutes.js";

dotenv.config();
const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Testar conexão
pool.query("SELECT NOW()", (err, res) => {
  if (err) console.error("Erro ao conectar no banco:", err);
  else console.log("Conectado ao banco! Hora atual:", res.rows[0].now);
});

// Rotas públicas
app.use("/api/auth", authRoutes);

// Rotas protegidas
app.use("/api/users", authMiddleware, userRoutes);
app.use("/api/products", authMiddleware, productRoutes);
app.use("/api/clients", authMiddleware, clientsRoutes);
app.use("/api/orders", authMiddleware, ordersRoutes);
app.use("/api/stock", authMiddleware, stockRoutes);

// Rota teste
app.get("/", (req, res) => res.send("API rodando 🚀"));

// Middleware de erros (sempre no final)
app.use(errorHandler);

app.listen(PORT, () => console.log(`Servidor rodando na porta ${PORT}`));
