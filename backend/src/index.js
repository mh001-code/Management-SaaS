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
import suppliersRoutes from "./routes/suppliersRoutes.js";
import financialRoutes from './routes/financialRoutes.js';
import purchaseOrdersRoutes from "./routes/purchaseOrdersRoutes.js";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(morgan("dev"));
app.use(cors());
app.use(express.json());

app.use("/api", (req, res, next) => {
  res.set("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate");
  res.set("Pragma", "no-cache");
  res.set("Expires", "0");
  next();
});

pool.query("SELECT NOW()", (err, res) => {
  if (err) console.error("Erro ao conectar no banco:", err);
  else console.log("Conectado ao banco! Hora atual:", res.rows[0].now);
});

swaggerDocs(app);
app.use(logMiddleware);

app.use("/api/auth", authRoutes);

app.use("/api/summary",         authMiddleware, summaryRoutes);
app.use("/api/reports",         authMiddleware, reportsRoutes);
app.use("/api/logs",            authMiddleware, logRoutes);
app.use("/api/users",           authMiddleware, userRoutes);
app.use("/api/products",        authMiddleware, productRoutes);
app.use("/api/clients",         authMiddleware, clientsRoutes);
app.use("/api/orders",          authMiddleware, ordersRoutes);
app.use("/api/financial",       authMiddleware, financialRoutes);
app.use("/api/suppliers",       authMiddleware, suppliersRoutes);
app.use("/api/purchase-orders", authMiddleware, purchaseOrdersRoutes);

app.get("/", (req, res) => res.send("API rodando 🚀"));

app.use(errorHandler);

app.listen(PORT, () => console.log(`Servidor rodando na porta ${PORT}`));
