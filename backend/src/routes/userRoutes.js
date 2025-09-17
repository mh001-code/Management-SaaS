import { Router } from "express";
import {
  getUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
} from "../controllers/userController.js";

const router = Router();

// Rotas CRUD
router.get("/", getUsers);             // Listar todos usuários
router.get("/:id", getUserById);      // Listar usuário por ID
router.post("/", createUser);         // Criar usuário
router.put("/:id", updateUser);       // Atualizar usuário
router.delete("/:id", deleteUser);    // Deletar usuário

export default router;
