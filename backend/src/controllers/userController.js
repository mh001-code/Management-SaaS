import bcrypt from "bcryptjs";
import * as UserModel from "../models/UserModel.js";

// Listar todos os usuários
export const getUsers = async (req, res, next) => {
  try {
    const users = await UserModel.getAllUsers();
    res.json(users);
  } catch (err) {
    next(err);
  }
};

// Listar usuário por ID
export const getUserById = async (req, res, next) => {
  const { id } = req.params;
  try {
    const user = await UserModel.getUserById(id);
    if (!user) {
      const error = new Error("Usuário não encontrado");
      error.statusCode = 404;
      return next(error);
    }
    res.json(user);
  } catch (err) {
    next(err);
  }
};

// Criar usuário
export const createUser = async (req, res, next) => {
  const { name, email, password } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = await UserModel.createUser(name, email, hashedPassword);
    res.status(201).json(newUser);
  } catch (err) {
    if (err.code === "23505") {
      const error = new Error("Email já cadastrado");
      error.statusCode = 400;
      return next(error);
    }
    next(err);
  }
};

// Atualizar usuário
export const updateUser = async (req, res, next) => {
  const { id } = req.params;
  const { name, email, password } = req.body;
  try {
    const hashedPassword = password ? await bcrypt.hash(password, 10) : undefined;
    const updatedUser = await UserModel.updateUser(id, name, email, hashedPassword);
    if (!updatedUser) {
      const error = new Error("Usuário não encontrado");
      error.statusCode = 404;
      return next(error);
    }
    res.json(updatedUser);
  } catch (err) {
    if (err.code === "23505") {
      const error = new Error("Email já cadastrado");
      error.statusCode = 400;
      return next(error);
    }
    next(err);
  }
};

// Deletar usuário
export const deleteUser = async (req, res, next) => {
  const { id } = req.params;
  try {
    const deletedUser = await UserModel.deleteUser(id);
    if (!deletedUser) {
      const error = new Error("Usuário não encontrado");
      error.statusCode = 404;
      return next(error);
    }
    res.json({ message: "Usuário deletado com sucesso" });
  } catch (err) {
    next(err);
  }
};
