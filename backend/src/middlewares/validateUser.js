import { body, validationResult } from "express-validator";

// Validação para criar usuário
export const validateUserCreation = [
  body("email").isEmail().withMessage("Email inválido"),
  body("password")
    .isLength({ min: 6 })
    .withMessage("Senha deve ter ao menos 6 caracteres"),
  body("name").notEmpty().withMessage("Nome é obrigatório"),
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
];

// Validação para atualizar usuário
export const validateUserUpdate = [
  body("email").optional().isEmail().withMessage("Email inválido"),
  body("password")
    .optional()
    .isLength({ min: 6 })
    .withMessage("Senha deve ter ao menos 6 caracteres"),
  body("name").optional().notEmpty().withMessage("Nome não pode ser vazio"),
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
];
