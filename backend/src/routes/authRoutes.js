/**
 * @swagger
 * tags:
 *   name: Auth
 *   description: Endpoints de autenticação
 */

/**
 * @swagger
 * /api/auth/register:
 *   post:
 *     summary: Registrar novo usuário
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - email
 *               - password
 *             properties:
 *               name:
 *                 type: string
 *                 example: "Márcio Henrique"
 *               email:
 *                 type: string
 *                 example: "marcio@email.com"
 *               password:
 *                 type: string
 *                 example: "123456"
 *     responses:
 *       201:
 *         description: Usuário criado
 *       400:
 *         description: Erro de validação
 */

/**
 * @swagger
 * /api/auth/login:
 *   post:
 *     summary: Login de usuário
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *             properties:
 *               email:
 *                 type: string
 *                 example: "marcio@email.com"
 *               password:
 *                 type: string
 *                 example: "123456"
 *     responses:
 *       200:
 *         description: Retorna JWT
 *       401:
 *         description: Credenciais inválidas
 */

import { Router } from "express";
import { login, register, me } from "../controllers/authController.js";
import { validateUserCreation } from "../middlewares/validateUser.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = Router();

router.post("/register", validateUserCreation, register);
router.post("/login", login);

// ✅ Rota protegida para restaurar sessão após F5
router.get("/me", authMiddleware, me);

export default router;