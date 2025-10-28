import * as ProductModel from "../models/ProductModel.js";
import * as StockModel from "../models/StockModel.js";

export const getProducts = async (req, res, next) => {
  try {
    const products = await ProductModel.getAllProductsWithStock();
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

// ✅ Criar produto e estoque
export const createProduct = async (req, res, next) => {
  try {
    const { name, description, price, stock_quantity } = req.body;
    if (!name || price === undefined) {
      const error = new Error("Nome e preço são obrigatórios");
      error.statusCode = 400;
      return next(error);
    }

    // 1️⃣ Cria produto
    const product = await ProductModel.createProduct({ name, description, price });

    console.log("✏️ Produto criado:", product);

    // 2️⃣ Cria registro de estoque, se fornecido
    if (stock_quantity !== undefined) {
      const stock = await StockModel.addStock(product.id, stock_quantity);
      console.log("🔹 Estoque criado:", stock);
    }

    res.status(201).json({ ...product, stock_quantity: stock_quantity || 0 });
  } catch (err) {
    next(err);
  }
};

// ✅ Atualizar produto e estoque
export const updateProduct = async (req, res, next) => {
  try {
    const productId = req.params.id;
    const { name, price, description, stock_quantity } = req.body;

    // 1️⃣ Atualiza produto
    const updatedProduct = await ProductModel.updateProduct(productId, { name, price, description });
    if (!updatedProduct) {
      const error = new Error("Produto não encontrado");
      error.statusCode = 404;
      return next(error);
    }
    console.log("✏️ Produto atualizado:", updatedProduct);

    // 2️⃣ Atualiza ou cria estoque
    let updatedStock;
    if (stock_quantity !== undefined) {
      updatedStock = await StockModel.upsertStock(productId, stock_quantity);
      console.log("🔹 Estoque atualizado:", updatedStock);
    }

    // 3️⃣ Retorna produto com estoque atualizado
    res.json({
      ...updatedProduct,
      stock_quantity: updatedStock?.quantity ?? stock_quantity ?? 0,
    });
  } catch (err) {
    next(err);
  }
};

// ✅ Deletar produto
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