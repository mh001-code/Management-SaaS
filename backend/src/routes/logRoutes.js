import { Router } from "express";
import { getLogs } from "../controllers/logController.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = Router();

// Apenas usuários autenticados podem consultar logs
router.use(authMiddleware);

router.get("/", getLogs);

export default router;
