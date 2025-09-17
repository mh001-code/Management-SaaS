// backend/src/controllers/clientsController.js
import * as ClientModel from "../models/ClientModel.js";

// Listar todos os clientes
export const getClients = async (req, res, next) => {
  try {
    const clients = await ClientModel.getAllClients();
    res.json(clients);
  } catch (err) {
    next(err);
  }
};

// Buscar cliente por ID
export const getClientById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const client = await ClientModel.getClientById(id);

    if (!client) {
      const error = new Error("Cliente não encontrado");
      error.statusCode = 404;
      return next(error);
    }

    res.json(client);
  } catch (err) {
    next(err);
  }
};

// Criar cliente
export const createClient = async (req, res, next) => {
  try {
    const { name, email, phone } = req.body;

    if (!name) {
      const error = new Error("Nome é obrigatório");
      error.statusCode = 400;
      return next(error);
    }

    const client = await ClientModel.createClient(name, email || "", phone || "");
    res.status(201).json(client);
  } catch (err) {
    if (err.code === "23505") {
      const error = new Error("Email já cadastrado");
      error.statusCode = 400;
      return next(error);
    }
    next(err);
  }
};

// Atualizar cliente
export const updateClient = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { name, email, phone } = req.body;

    const updatedClient = await ClientModel.updateClient(id, name, email, phone);

    if (!updatedClient) {
      const error = new Error("Cliente não encontrado");
      error.statusCode = 404;
      return next(error);
    }

    res.json(updatedClient);
  } catch (err) {
    if (err.code === "23505") {
      const error = new Error("Email já cadastrado");
      error.statusCode = 400;
      return next(error);
    }
    next(err);
  }
};

// Deletar cliente
export const deleteClient = async (req, res, next) => {
  try {
    const { id } = req.params;
    const deletedClient = await ClientModel.deleteClient(id);

    if (!deletedClient) {
      const error = new Error("Cliente não encontrado");
      error.statusCode = 404;
      return next(error);
    }

    res.json({ message: "Cliente deletado com sucesso" });
  } catch (err) {
    next(err);
  }
};
