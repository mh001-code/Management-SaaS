import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import * as UserModel from "../models/UserModel.js";

// 📌 Registrar novo usuário
export const registerUser = async (req, res, next) => {
  const { name, email, password } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = await UserModel.createUser(name, email, hashedPassword);

    res.status(201).json({
      message: "Usuário registrado com sucesso",
      user: { id: newUser.id, name: newUser.name, email: newUser.email }
    });
  } catch (err) {
    if (err.code === "23505") {
      const error = new Error("Email já cadastrado");
      error.statusCode = 400;
      return next(error);
    }
    next(err);
  }
};

// 📌 Login de usuário
export const loginUser = async (req, res, next) => {
  const { email, password } = req.body;
  try {
    const user = await UserModel.getUserByEmail(email);
    if (!user) {
      return res.status(400).json({ error: "Usuário não encontrado" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ error: "Senha incorreta" });
    }

    const token = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: "1h" }
    );

    res.json({
      message: "Login bem-sucedido",
      token,
      user: { id: user.id, name: user.name, email: user.email }
    });
  } catch (err) {
    next(err);
  }
};

// 📌 Listar todos os usuários
export const getUsers = async (req, res, next) => {
  try {
    const users = await UserModel.getAllUsers();
    res.json(users);
  } catch (err) {
    next(err);
  }
};

// 📌 Buscar usuário por ID
export const getUserById = async (req, res, next) => {
  const { id } = req.params;
  try {
    // Permitir acesso se for admin ou se for o próprio usuário
    if (req.user.role !== "admin" && req.user.userId !== parseInt(id)) {
      return res.status(403).json({ error: "Acesso negado" });
    }

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

// 📌 Atualizar usuário
export const updateUser = async (req, res, next) => {
  const { id } = req.params;
  const { name, email, password, role } = req.body;

  try {
    const hashedPassword = password ? await bcrypt.hash(password, 10) : undefined;

    let updatedUser;
    if (req.user.role === "admin") {
      // Admin pode atualizar tudo
      updatedUser = await UserModel.updateUser(id, name, email, hashedPassword, role);
    } else {
      // Usuário comum só pode atualizar nome, email e senha
      updatedUser = await UserModel.updateUser(id, name, email, hashedPassword);
    }

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
      return next(err);
    }
    next(err);
  }
};

// 📌 Deletar usuário
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
