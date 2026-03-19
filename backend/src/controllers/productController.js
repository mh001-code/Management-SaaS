import * as ProductModel from "../models/ProductModel.js";
import * as StockModel from "../models/StockModel.js";
import pool from "../config/db.js";

export const getProducts = async (req, res, next) => {
  try {
    res.json(await ProductModel.getAllProductsWithStock());
  } catch (err) { next(err); }
};

export const getProductById = async (req, res, next) => {
  try {
    const product = await ProductModel.getProductById(req.params.id);
    if (!product) {
      const error = new Error("Produto não encontrado"); error.statusCode = 404; return next(error);
    }
    res.json(product);
  } catch (err) { next(err); }
};

export const createProduct = async (req, res, next) => {
  try {
    const { name, description, price, stock_quantity } = req.body;

    // ── Regras de negócio ──────────────────────────────────────────────────
    if (!name || !name.trim()) {
      const e = new Error("Nome do produto é obrigatório"); e.statusCode = 400; return next(e);
    }
    if (price === undefined || price === null || Number(price) <= 0) {
      const e = new Error("Preço deve ser maior que zero"); e.statusCode = 400; return next(e);
    }
    if (stock_quantity !== undefined && Number(stock_quantity) < 0) {
      const e = new Error("Estoque não pode ser negativo"); e.statusCode = 400; return next(e);
    }

    // Nome único (case-insensitive)
    const dup = await pool.query(
      "SELECT id FROM products WHERE LOWER(name) = LOWER($1)", [name.trim()]
    );
    if (dup.rows.length > 0) {
      const e = new Error(`Já existe um produto com o nome "${name.trim()}"`); e.statusCode = 409; return next(e);
    }

    const product = await ProductModel.createProduct({ name: name.trim(), description, price: Number(price) });
    if (stock_quantity !== undefined) {
      await StockModel.addStock(product.id, Number(stock_quantity));
    }
    res.status(201).json({ ...product, stock_quantity: Number(stock_quantity) || 0 });
  } catch (err) { next(err); }
};

export const updateProduct = async (req, res, next) => {
  try {
    const productId = req.params.id;
    const { name, price, description, stock_quantity } = req.body;

    if (price !== undefined && Number(price) <= 0) {
      const e = new Error("Preço deve ser maior que zero"); e.statusCode = 400; return next(e);
    }
    if (stock_quantity !== undefined && Number(stock_quantity) < 0) {
      const e = new Error("Estoque não pode ser negativo"); e.statusCode = 400; return next(e);
    }

    // Nome único ao editar (excluindo o próprio produto)
    if (name) {
      const dup = await pool.query(
        "SELECT id FROM products WHERE LOWER(name) = LOWER($1) AND id <> $2",
        [name.trim(), productId]
      );
      if (dup.rows.length > 0) {
        const e = new Error(`Já existe outro produto com o nome "${name.trim()}"`); e.statusCode = 409; return next(e);
      }
    }

    const updatedProduct = await ProductModel.updateProduct(productId, { name, price, description });
    if (!updatedProduct) {
      const e = new Error("Produto não encontrado"); e.statusCode = 404; return next(e);
    }

    let updatedStock;
    if (stock_quantity !== undefined) {
      updatedStock = await StockModel.upsertStock(productId, Number(stock_quantity));
    }
    res.json({ ...updatedProduct, stock_quantity: updatedStock?.quantity ?? stock_quantity ?? 0 });
  } catch (err) { next(err); }
};

export const deleteProduct = async (req, res, next) => {
  try {
    // Não permite deletar produto com pedidos ativos
    const activeOrders = await pool.query(
      `SELECT COUNT(*) FROM order_items oi
       JOIN orders o ON o.id = oi.order_id
       WHERE oi.product_id = $1 AND o.status NOT IN ('cancelado','estornado','recusado')`,
      [req.params.id]
    );
    if (Number(activeOrders.rows[0].count) > 0) {
      const e = new Error("Não é possível excluir produto com pedidos ativos");
      e.statusCode = 409; return next(e);
    }

    const deleted = await ProductModel.deleteProduct(req.params.id);
    if (!deleted) {
      const e = new Error("Produto não encontrado"); e.statusCode = 404; return next(e);
    }
    res.json({ message: "Produto deletado com sucesso" });
  } catch (err) { next(err); }
};