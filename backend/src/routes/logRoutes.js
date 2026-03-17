import { Router } from "express";
import { getLogs } from "../controllers/logController.js";

const router = Router();

// ✅ authMiddleware removido daqui — já aplicado em index.js
router.get("/", getLogs);

export default router;