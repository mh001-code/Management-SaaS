import { Router } from "express";
import {
  getProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
} from "../controllers/productController.js";
import { validateProduct, validateProductUpdate } from "../middlewares/validateProduct.js";

const router = Router();

router.get("/",    getProducts);
router.get("/:id", getProductById);
router.post("/",   validateProduct,       createProduct);
router.put("/:id", validateProductUpdate, updateProduct);
router.delete("/:id", deleteProduct);

export default router;
