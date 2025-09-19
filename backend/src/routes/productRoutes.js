/**
 * @swagger
 * tags:
 *   name: Products
 *   description: Endpoints para gerenciamento de produtos
 */

/**
 * @swagger
 * /api/products:
 *   get:
 *     summary: Listar todos produtos
 *     tags: [Products]
 *     responses:
 *       200:
 *         description: Lista de produtos
 */

/**
 * @swagger
 * /api/products/{id}:
 *   get:
 *     summary: Buscar produto por ID
 *     tags: [Products]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *     responses:
 *       200:
 *         description: Produto encontrado
 *       404:
 *         description: Produto não encontrado
 */

/**
 * @swagger
 * /api/products:
 *   post:
 *     summary: Criar novo produto
 *     tags: [Products]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - price
 *             properties:
 *               name:
 *                 type: string
 *               description:
 *                 type: string
 *               price:
 *                 type: number
 *               stock:
 *                 type: integer
 *     responses:
 *       201:
 *         description: Produto criado
 */

/**
 * @swagger
 * /api/products/{id}:
 *   put:
 *     summary: Atualizar produto
 *     tags: [Products]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               description:
 *                 type: string
 *               price:
 *                 type: number
 *               stock:
 *                 type: integer
 *     responses:
 *       200:
 *         description: Produto atualizado
 *       404:
 *         description: Produto não encontrado
 */

/**
 * @swagger
 * /api/products/{id}:
 *   delete:
 *     summary: Deletar produto
 *     tags: [Products]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Produto deletado
 *       404:
 *         description: Produto não encontrado
 */

import { Router } from "express";
import {
  getProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
} from "../controllers/productController.js";
import authMiddleware from "../middlewares/authMiddleware.js";
import { validateProduct } from "../middlewares/validateProduct.js"; // ✅ importar validação

const router = Router();

// Todas as rotas protegidas por JWT
router.use(authMiddleware);

router.get("/", getProducts);
router.get("/:id", getProductById);
router.post("/", validateProduct, createProduct);   // ✅ validação no POST
router.put("/:id", validateProduct, updateProduct); // ✅ validação no PUT
router.delete("/:id", deleteProduct);

export default router;
