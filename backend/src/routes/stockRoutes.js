/**
 * @swagger
 * tags:
 *   name: Stock
 *   description: Endpoints de estoque
 */

/**
 * @swagger
 * /api/stock:
 *   get:
 *     summary: Listar todo o estoque
 *     tags: [Stock]
 *     responses:
 *       200:
 *         description: Lista de estoque de produtos
 */

/**
 * @swagger
 * /api/stock:
 *   post:
 *     summary: Adicionar produto ao estoque
 *     tags: [Stock]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - product_id
 *               - quantity
 *             properties:
 *               product_id:
 *                 type: integer
 *                 example: 2
 *               quantity:
 *                 type: integer
 *                 example: 10
 *     responses:
 *       201:
 *         description: Produto adicionado ao estoque
 *       400:
 *         description: Dados inválidos
 */

/**
 * @swagger
 * /api/stock:
 *   put:
 *     summary: Atualizar estoque de um produto
 *     tags: [Stock]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - product_id
 *               - quantity
 *             properties:
 *               product_id:
 *                 type: integer
 *                 example: 2
 *               quantity:
 *                 type: integer
 *                 example: 15
 *     responses:
 *       200:
 *         description: Estoque atualizado
 *       404:
 *         description: Produto não encontrado
 */

import { Router } from "express";
import { getStock, updateStock, addStock } from "../controllers/stockController.js";

const router = Router();

router.get("/", getStock);        // Listar todo estoque
router.post("/", addStock);       // Adicionar novo produto ao estoque
router.put("/", updateStock);     // Atualizar quantidade existente

export default router;
