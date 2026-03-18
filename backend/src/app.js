import express from "express";
import cors from "cors";
import morgan from "morgan";
import userRoutes from "./routes/userRoutes.js";
import authRoutes from "./routes/authRoutes.js";
import authMiddleware from "./middlewares/authMiddleware.js";
import errorHandler from "./middlewares/errorHandler.js";
import productRoutes from "./routes/productRoutes.js";
import clientsRoutes from "./routes/clientsRoutes.js";
import ordersRoutes from "./routes/ordersRoutes.js";
import reportsRoutes from "./routes/reportsRoutes.js";
import logMiddleware from "./middlewares/logMiddleware.js";
import logRoutes from "./routes/logRoutes.js";
import summaryRoutes from "./routes/summaryRoutes.js";
import suppliersRoutes from "./routes/suppliersRoutes.js";
import purchaseOrdersRoutes from "./routes/purchaseOrdersRoutes.js";
import { swaggerDocs } from "./docs.js";

const app = express();

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

swaggerDocs(app);
app.use(logMiddleware);

// Rotas públicas
app.use("/api/auth", authRoutes);

// Rotas protegidas
app.use("/api/summary", authMiddleware, summaryRoutes);
app.use("/api/reports", authMiddleware, reportsRoutes);
app.use("/api/logs", authMiddleware, logRoutes);
app.use("/api/users", authMiddleware, userRoutes);
app.use("/api/products", authMiddleware, productRoutes);
app.use("/api/clients", authMiddleware, clientsRoutes);
app.use("/api/orders", authMiddleware, ordersRoutes);

app.use("/api/suppliers",       authMiddleware, suppliersRoutes);
app.use("/api/purchase-orders", authMiddleware, purchaseOrdersRoutes);

app.get("/", (req, res) => res.send("API rodando 🚀"));

app.use(errorHandler);

export default app;
