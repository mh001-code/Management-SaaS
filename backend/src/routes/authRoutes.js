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
 *                 example: "senha_forte_aqui"
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
 *                 example: "senha_forte_aqui"
 *     responses:
 *       200:
 *         description: Retorna JWT
 *       401:
 *         description: Credenciais inválidas
 *       429:
 *         description: Muitas tentativas — tente novamente em 15 minutos
 */

import { Router } from "express";
import rateLimit from "express-rate-limit";
import { login, register, me } from "../controllers/authController.js";
import { validateUserCreation } from "../middlewares/validateUser.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = Router();

// ✅ Proteção contra força bruta — máximo 10 tentativas por IP a cada 15 minutos
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    error: "Muitas tentativas de login. Tente novamente em 15 minutos.",
  },
});

router.post("/register", validateUserCreation, register);
router.post("/login", loginLimiter, login);
router.get("/me", authMiddleware, me);

export default router;