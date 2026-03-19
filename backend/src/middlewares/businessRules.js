/**
 * businessRules.js
 * Middleware de validação de regras de negócio reutilizáveis.
 * Usado pelas rotas antes de chegar no controller.
 */

// Valida que campos obrigatórios existem no body
export const requireFields = (...fields) => (req, res, next) => {
  const missing = fields.filter(f => {
    const val = req.body[f];
    return val === undefined || val === null || String(val).trim() === "";
  });
  if (missing.length > 0) {
    return res.status(400).json({
      error: `Campos obrigatórios: ${missing.join(", ")}`,
    });
  }
  next();
};

// Valida formato de e-mail (se presente)
export const validateEmail = (field = "email") => (req, res, next) => {
  const email = req.body[field];
  if (!email) return next(); // campo opcional
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!regex.test(email)) {
    return res.status(400).json({ error: "Formato de e-mail inválido" });
  }
  next();
};

// Valida que um valor numérico é positivo
export const requirePositive = (...fields) => (req, res, next) => {
  for (const field of fields) {
    const val = req.body[field];
    if (val !== undefined && Number(val) <= 0) {
      return res.status(400).json({
        error: `O campo "${field}" deve ser maior que zero`,
      });
    }
  }
  next();
};

// Valida que arrays não estão vazios
export const requireNonEmptyArray = (field) => (req, res, next) => {
  const val = req.body[field];
  if (!Array.isArray(val) || val.length === 0) {
    return res.status(400).json({
      error: `O campo "${field}" deve conter ao menos um item`,
    });
  }
  next();
};
