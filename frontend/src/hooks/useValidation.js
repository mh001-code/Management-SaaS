import { useState, useCallback } from "react";

/**
 * useValidation
 *
 * Regras disponíveis por campo:
 *   required   — campo obrigatório
 *   min        — tamanho mínimo (string) ou valor mínimo (number)
 *   max        — tamanho máximo (string) ou valor máximo (number)
 *   email      — formato de e-mail válido
 *   positive   — número maior que zero
 *   match      — deve ser igual ao valor de outro campo (ex: confirmar senha)
 *   pattern    — regex personalizado
 *   custom     — função (value, values) => string | null
 *
 * Uso:
 *   const { errors, touched, validate, touch, touchAll, isValid } = useValidation(rules);
 */

const VALIDATORS = {
  required: (v) =>
    v === undefined || v === null || String(v).trim() === ""
      ? "Campo obrigatório"
      : null,

  email: (v) =>
    v && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(v))
      ? "E-mail inválido"
      : null,

  positive: (v) =>
    v !== "" && v !== undefined && Number(v) <= 0
      ? "Deve ser maior que zero"
      : null,

  min: (v, param) => {
    if (v === undefined || v === null || v === "") return null;
    if (typeof v === "string" && v.length < param)
      return `Mínimo ${param} caracteres`;
    if (typeof v === "number" && v < param)
      return `Mínimo ${param}`;
    return null;
  },

  max: (v, param) => {
    if (v === undefined || v === null || v === "") return null;
    if (typeof v === "string" && v.length > param)
      return `Máximo ${param} caracteres`;
    if (typeof v === "number" && v > param)
      return `Máximo ${param}`;
    return null;
  },

  match: (v, param, values) =>
    v !== values[param] ? "Os campos não coincidem" : null,

  pattern: (v, param) =>
    v && !new RegExp(param).test(String(v)) ? "Formato inválido" : null,
};

export function useValidation(rules = {}) {
  const [errors, setErrors]   = useState({});
  const [touched, setTouched] = useState({});

  const validateField = useCallback(
    (name, value, allValues) => {
      const fieldRules = rules[name];
      if (!fieldRules) return null;

      for (const [rule, param] of Object.entries(fieldRules)) {
        if (rule === "custom") {
          const msg = param(value, allValues);
          if (msg) return msg;
          continue;
        }
        const validator = VALIDATORS[rule];
        if (!validator) continue;
        const msg = validator(value, param, allValues);
        if (msg) return msg;
      }
      return null;
    },
    [rules]
  );

  const validate = useCallback(
    (values) => {
      const newErrors = {};
      for (const name of Object.keys(rules)) {
        const msg = validateField(name, values[name], values);
        if (msg) newErrors[name] = msg;
      }
      setErrors(newErrors);
      return Object.keys(newErrors).length === 0;
    },
    [rules, validateField]
  );

  const touch = useCallback((name, values) => {
    setTouched((prev) => ({ ...prev, [name]: true }));
    if (values !== undefined) {
      const msg = validateField(name, values[name], values);
      setErrors((prev) => ({
        ...prev,
        [name]: msg ?? undefined,
      }));
    }
  }, [validateField]);

  const touchAll = useCallback((values) => {
    const allTouched = Object.keys(rules).reduce((acc, k) => ({ ...acc, [k]: true }), {});
    setTouched(allTouched);
    return validate(values);
  }, [rules, validate]);

  const clearErrors = useCallback(() => {
    setErrors({});
    setTouched({});
  }, []);

  const isValid = Object.keys(errors).length === 0;

  return { errors, touched, validate, touch, touchAll, clearErrors, isValid };
}
