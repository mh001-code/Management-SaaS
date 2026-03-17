import { Router } from "express";
import { getSummary } from "../controllers/summaryController.js";

const router = Router();

// ✅ authMiddleware e cache headers removidos daqui — já aplicados em index.js
router.get("/", getSummary);

export default router;