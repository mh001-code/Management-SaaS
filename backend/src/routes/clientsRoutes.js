/**
 * @swagger
 * tags:
 *   name: Clients
 *   description: Endpoints de clientes
 */

/**
 * @swagger
 * /api/clients:
 *   get:
 *     summary: Listar todos os clientes
 *     tags: [Clients]
 *     responses:
 *       200:
 *         description: Lista de clientes
 */

/**
 * @swagger
 * /api/clients/{id}:
 *   get:
 *     summary: Buscar cliente por ID
 *     tags: [Clients]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID do cliente
 *     responses:
 *       200:
 *         description: Cliente encontrado
 *       404:
 *         description: Cliente não encontrado
 */

/**
 * @swagger
 * /api/clients:
 *   post:
 *     summary: Criar um novo cliente
 *     tags: [Clients]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - email
 *             properties:
 *               name:
 *                 type: string
 *                 example: "João da Silva"
 *               email:
 *                 type: string
 *                 example: "joao@email.com"
 *               phone:
 *                 type: string
 *                 example: "11999999999"
 *     responses:
 *       201:
 *         description: Cliente criado
 *       400:
 *         description: Erro de validação
 */

/**
 * @swagger
 * /api/clients/{id}:
 *   put:
 *     summary: Atualizar cliente
 *     tags: [Clients]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID do cliente
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 example: "João da Silva"
 *               email:
 *                 type: string
 *                 example: "joao@email.com"
 *               phone:
 *                 type: string
 *                 example: "11999999999"
 *     responses:
 *       200:
 *         description: Cliente atualizado
 *       404:
 *         description: Cliente não encontrado
 */

/**
 * @swagger
 * /api/clients/{id}:
 *   delete:
 *     summary: Deletar cliente
 *     tags: [Clients]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID do cliente
 *     responses:
 *       200:
 *         description: Cliente deletado
 *       404:
 *         description: Cliente não encontrado
 */

import { Router } from "express";
import {
  getClients,
  getClientById,
  createClient,
  updateClient,
  deleteClient,
} from "../controllers/clientsController.js";

const router = Router();

router.get("/", getClients);
router.get("/:id", getClientById);
router.post("/", createClient);
router.put("/:id", updateClient);
router.delete("/:id", deleteClient);

export default router;
