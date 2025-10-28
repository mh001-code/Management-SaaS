import * as StockModel from '../models/StockModel.js';

// Adicionar entrada/ajuste
export const addStock = async (req, res, next) => {
  try {
    const { product_id, quantity, type, reference_id } = req.body;
    if (!product_id || quantity === undefined || !type) {
      return res.status(400).json({ error: 'product_id, quantity e type são obrigatórios' });
    }

    const movement = await StockModel.addStockMovement({ product_id, quantity, type, reference_id });
    res.status(201).json(movement);
  } catch (err) {
    next(err);
  }
};

// Consultar estoque atual
export const getStock = async (req, res, next) => {
  try {
    const { product_id } = req.query;
    if (!product_id) return res.status(400).json({ error: 'product_id é obrigatório' });

    const stock_quantity = await StockModel.getCurrentStock(product_id);
    res.json({ product_id, stock_quantity });
  } catch (err) {
    next(err);
  }
};