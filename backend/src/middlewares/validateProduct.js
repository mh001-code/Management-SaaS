import { body, validationResult } from "express-validator";

export const validateProduct = [
  body("name").notEmpty().withMessage("Nome é obrigatório"),
  body("price").isFloat({ gt: 0 }).withMessage("Preço deve ser maior que 0"),
  body("stock").optional().isInt({ min: 0 }).withMessage("Estoque inválido"),

  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  }
];
