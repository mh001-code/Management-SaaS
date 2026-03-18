import { Router } from "express";
import {
  getPurchaseOrders, getPurchaseOrderById,
  createPurchaseOrder, updatePurchaseOrderStatus,
  deletePurchaseOrder,
} from "../controllers/purchaseOrdersController.js";

const router = Router();

router.get("/",           getPurchaseOrders);
router.get("/:id",        getPurchaseOrderById);
router.post("/",          createPurchaseOrder);
router.put("/:id/status", updatePurchaseOrderStatus);
router.delete("/:id",     deletePurchaseOrder);

export default router;
