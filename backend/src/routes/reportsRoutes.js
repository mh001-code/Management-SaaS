import { Router } from "express";
import { getSummaryReport } from "../controllers/reportsController.js";

const router = Router();

// ✅ authMiddleware removido daqui — já aplicado em index.js
router.get("/summary", getSummaryReport);

export default router;