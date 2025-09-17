import { Router } from "express";
import { getStock, updateStock, addStock } from "../controllers/stockController.js";

const router = Router();

router.get("/", getStock);        // Listar todo estoque
router.post("/", addStock);       // Adicionar novo produto ao estoque
router.put("/", updateStock);     // Atualizar quantidade existente

export default router;
