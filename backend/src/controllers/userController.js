import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import * as UserModel from "../models/UserModel.js";
import pool from "../config/db.js";

export const registerUser = async (req, res, next) => {
  const { name, email, password } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 12);
    const newUser = await UserModel.createUser(name, email, hashedPassword);
    res.status(201).json({
      message: "Usuário registrado com sucesso",
      user: { id: newUser.id, name: newUser.name, email: newUser.email },
    });
  } catch (err) {
    if (err.code === "23505") {
      const error = new Error("Email já cadastrado"); error.statusCode = 400; return next(error);
    }
    next(err);
  }
};

export const loginUser = async (req, res, next) => {
  const { email, password } = req.body;
  try {
    const user = await UserModel.getUserByEmail(email);
    if (!user) return res.status(400).json({ error: "Usuário não encontrado" });
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ error: "Senha incorreta" });
    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: "1h" }
    );
    res.json({ message: "Login bem-sucedido", token, user: { id: user.id, name: user.name, email: user.email, role: user.role } });
  } catch (err) { next(err); }
};

export const getUsers = async (req, res, next) => {
  if (req.user.role !== "admin")
    return res.status(403).json({ error: "Você não tem permissão para acessar esta página." });
  try {
    res.json(await UserModel.getAllUsers());
  } catch (err) { next(err); }
};

export const getUserById = async (req, res, next) => {
  const { id } = req.params;
  try {
    if (req.user.role !== "admin" && req.user.userId !== parseInt(id))
      return res.status(403).json({ error: "Acesso negado" });
    const user = await UserModel.getUserById(id);
    if (!user) {
      const error = new Error("Usuário não encontrado"); error.statusCode = 404; return next(error);
    }
    res.json(user);
  } catch (err) { next(err); }
};

export const updateUser = async (req, res, next) => {
  const { id } = req.params;
  const { name, email, password, role } = req.body;
  try {
    // Só admin pode alterar role
    if (role && req.user.role !== "admin")
      return res.status(403).json({ error: "Apenas administradores podem alterar funções" });

    // Não permite rebaixar o único admin
    if (role === "user") {
      const adminCount = await pool.query(
        "SELECT COUNT(*) FROM users WHERE role = 'admin' AND id <> $1", [id]
      );
      if (Number(adminCount.rows[0].count) === 0) {
        const e = new Error("Não é possível rebaixar o único administrador do sistema");
        e.statusCode = 409; return next(e);
      }
    }

    // Senha mínima ao alterar
    if (password && password.trim().length > 0 && password.trim().length < 6) {
      const e = new Error("A nova senha deve ter pelo menos 6 caracteres");
      e.statusCode = 400; return next(e);
    }

    let hashedPassword;
    if (password && password.trim() !== "") {
      hashedPassword = await bcrypt.hash(password, 12);
    }

    const updatedUser = req.user.role === "admin"
      ? await UserModel.updateUser(id, name, email, hashedPassword, role)
      : await UserModel.updateUser(id, name, email, hashedPassword);

    if (!updatedUser) return res.status(404).json({ error: "Usuário não encontrado" });
    res.json({ message: "Usuário atualizado com sucesso", user: updatedUser });
  } catch (err) { next(err); }
};

export const deleteUser = async (req, res, next) => {
  const { id } = req.params;
  try {
    // Não permite auto-exclusão
    if (req.user.userId === parseInt(id)) {
      const e = new Error("Você não pode excluir sua própria conta");
      e.statusCode = 409; return next(e);
    }

    // Não permite deletar o único admin
    const userToDelete = await UserModel.getUserById(id);
    if (userToDelete?.role === "admin") {
      const adminCount = await pool.query("SELECT COUNT(*) FROM users WHERE role = 'admin'");
      if (Number(adminCount.rows[0].count) <= 1) {
        const e = new Error("Não é possível excluir o único administrador do sistema");
        e.statusCode = 409; return next(e);
      }
    }

    const deletedUser = await UserModel.deleteUser(id);
    if (!deletedUser) {
      const error = new Error("Usuário não encontrado"); error.statusCode = 404; return next(error);
    }
    res.json({ message: "Usuário deletado com sucesso" });
  } catch (err) { next(err); }
};