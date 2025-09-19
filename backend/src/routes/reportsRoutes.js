import { Router } from "express";
import { getSummaryReport } from "../controllers/reportsController.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = Router();

// Todas as rotas de relatórios protegidas por JWT
router.use(authMiddleware);

// GET /api/reports/summary
router.get("/summary", getSummaryReport);

export default router;
