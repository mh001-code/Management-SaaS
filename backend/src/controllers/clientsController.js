import * as ClientModel from "../models/ClientModel.js";

export const getClients = async (req, res, next) => {
  try {
    res.json(await ClientModel.getAllClients());
  } catch (err) { next(err); }
};

export const getClientById = async (req, res, next) => {
  try {
    const client = await ClientModel.getClientById(req.params.id);
    if (!client) {
      const error = new Error("Cliente não encontrado");
      error.statusCode = 404;
      return next(error);
    }
    res.json(client);
  } catch (err) { next(err); }
};

export const createClient = async (req, res, next) => {
  try {
    const { name, email, phone, address } = req.body;
    if (!name) {
      const error = new Error("Nome é obrigatório");
      error.statusCode = 400;
      return next(error);
    }
    const client = await ClientModel.createClient(name, email, phone, address);
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

export const updateClient = async (req, res, next) => {
  try {
    const { name, email, phone, address } = req.body;
    const updated = await ClientModel.updateClient(
      req.params.id, name, email, phone, address
    );
    if (!updated) {
      const error = new Error("Cliente não encontrado");
      error.statusCode = 404;
      return next(error);
    }
    res.json(updated);
  } catch (err) {
    if (err.code === "23505") {
      const error = new Error("Email já cadastrado");
      error.statusCode = 400;
      return next(error);
    }
    next(err);
  }
};

export const deleteClient = async (req, res, next) => {
  try {
    const deleted = await ClientModel.deleteClient(req.params.id);
    if (!deleted) {
      const error = new Error("Cliente não encontrado");
      error.statusCode = 404;
      return next(error);
    }
    res.json({ message: "Cliente deletado com sucesso" });
  } catch (err) { next(err); }
};
