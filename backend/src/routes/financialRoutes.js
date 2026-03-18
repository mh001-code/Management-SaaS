import { Router } from "express";
import {
  getCategories,
  getTransactions, getTransactionById,
  createTransaction, updateTransaction, deleteTransaction,
  getCashFlow,
} from "../controllers/financialController.js";

const router = Router();

router.get("/categories",  getCategories);
router.get("/cash-flow",   getCashFlow);
router.get("/",            getTransactions);
router.get("/:id",         getTransactionById);
router.post("/",           createTransaction);
router.put("/:id",         updateTransaction);
router.delete("/:id",      deleteTransaction);

export default router;
