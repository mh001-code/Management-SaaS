import { Router } from "express";
import { getSummary } from "../controllers/dashboardController.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = Router();

// Protege a rota com JWT
router.get("/summary", authMiddleware, getSummary);

export default router;