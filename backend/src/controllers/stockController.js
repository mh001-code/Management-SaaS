// backend/src/controllers/stockController.js
import * as StockModel from "../models/StockModel.js";

// Listar estoque de todos produtos
export const getStock = async (req, res, next) => {
  try {
    const stock = await StockModel.getAllStock();
    res.json(stock);
  } catch (err) {
    next(err);
  }
};

// Atualizar estoque de um produto
export const updateStock = async (req, res, next) => {
  try {
    const { product_id, quantity } = req.body;

    if (!product_id || quantity === undefined) {
      const error = new Error("product_id e quantity são obrigatórios");
      error.statusCode = 400;
      return next(error);
    }

    const updatedStock = await StockModel.updateStock(product_id, quantity);

    if (!updatedStock) {
      const error = new Error("Produto não encontrado no estoque");
      error.statusCode = 404;
      return next(error);
    }

    res.json(updatedStock);
  } catch (err) {
    next(err);
  }
};

// Adicionar novo produto ao estoque
export const addStock = async (req, res, next) => {
  try {
    const { product_id, quantity } = req.body;

    if (!product_id || quantity === undefined) {
      const error = new Error("product_id e quantity são obrigatórios");
      error.statusCode = 400;
      return next(error);
    }

    const stock = await StockModel.addStock(product_id, quantity);
    res.status(201).json(stock);
  } catch (err) {
    next(err);
  }
};
