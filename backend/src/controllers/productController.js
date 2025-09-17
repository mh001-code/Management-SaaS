// backend/src/controllers/productController.js
import * as ProductModel from "../models/ProductModel.js";

export const getProducts = async (req, res, next) => {
  try {
    const products = await ProductModel.getAllProducts();
    res.json(products);
  } catch (err) {
    next(err);
  }
};

export const getProductById = async (req, res, next) => {
  try {
    const product = await ProductModel.getProductById(req.params.id);
    if (!product) {
      const error = new Error("Produto não encontrado");
      error.statusCode = 404;
      return next(error);
    }
    res.json(product);
  } catch (err) {
    next(err);
  }
};

export const createProduct = async (req, res, next) => {
  try {
    const { name, description, price, stock } = req.body;
    if (!name || price === undefined) {
      const error = new Error("Nome e preço são obrigatórios");
      error.statusCode = 400;
      return next(error);
    }
    const product = await ProductModel.createProduct({ name, description, price, stock });
    res.status(201).json(product);
  } catch (err) {
    next(err);
  }
};

export const updateProduct = async (req, res, next) => {
  try {
    const product = await ProductModel.updateProduct(req.params.id, req.body);
    if (!product) {
      const error = new Error("Produto não encontrado");
      error.statusCode = 404;
      return next(error);
    }
    res.json(product);
  } catch (err) {
    next(err);
  }
};

export const deleteProduct = async (req, res, next) => {
  try {
    const deleted = await ProductModel.deleteProduct(req.params.id);
    if (!deleted) {
      const error = new Error("Produto não encontrado");
      error.statusCode = 404;
      return next(error);
    }
    res.json({ message: "Produto deletado com sucesso" });
  } catch (err) {
    next(err);
  }
};
