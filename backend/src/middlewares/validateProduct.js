import { body, validationResult } from "express-validator";

// Validação para CRIAR produto — price obrigatório e > 0
export const validateProduct = [
  body("name").notEmpty().withMessage("Nome é obrigatório"),
  body("price").isFloat({ gt: 0 }).withMessage("Preço deve ser maior que 0"),
  body("stock_quantity").optional().isInt({ min: 0 }).withMessage("Estoque inválido"),
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
];

// Validação para ATUALIZAR produto — todos os campos opcionais
export const validateProductUpdate = [
  body("name").optional().notEmpty().withMessage("Nome não pode ser vazio"),
  body("price").optional().isFloat({ gt: 0 }).withMessage("Preço deve ser maior que 0"),
  body("stock_quantity").optional().isInt({ min: 0 }).withMessage("Estoque inválido"),
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
];
