import { Router } from "express";
import { getSummary } from "../controllers/summaryController.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = Router();

// Rota protegida: precisa estar logado
// Middleware para desabilitar cache + getSummary
router.get(
  "/",
  authMiddleware,
  (req, res, next) => {
    res.set("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate");
    res.set("Pragma", "no-cache");
    res.set("Expires", "0");
    next();
  },
  getSummary
);

export default router;
