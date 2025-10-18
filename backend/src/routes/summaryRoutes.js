import { Router } from "express";
import { getSummary } from "../controllers/summaryController.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = Router();

// Rota protegida: precisa estar logado
router.get("/", authMiddleware, (req, res, next) => {
  res.set("Cache-Control", "no-store"); // evita 304
  next();
}, getSummary);

export default router;
