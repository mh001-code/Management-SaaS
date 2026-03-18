import React, { memo, useCallback, useEffect } from "react";
import Input from "./ui/Input";
import Button from "./ui/Button";
import { useValidation } from "../hooks/useValidation";

/**
 * DataForm
 *
 * Campos suportados: text | email | password | number | textarea | select
 *
 * Regras de validação por campo — passadas via prop `validationRules`:
 *   {
 *     email:    { required: true, email: true },
 *     password: { required: true, min: 6 },
 *     price:    { required: true, positive: true },
 *   }
 *
 * Regras padrão inferidas automaticamente quando validationRules não é passado:
 *   - campos com required:true recebem { required: true }
 *   - campos do tipo email recebem { email: true }
 */
const DataForm = memo(({
  fields = [],
  values = {},
  isSubmitting = false,
  onSubmit = null,
  onCancel = null,
  onFieldChange = null,
  onFieldBlur = null,
  submitLabel = "Salvar",
  cancelLabel = "Cancelar",
  validationRules = null,
}) => {
  // Infere regras quando não fornecidas explicitamente
  const rules = validationRules ?? fields.reduce((acc, f) => {
    const r = {};
    if (f.required) r.required = true;
    if (f.type === "email") r.email = true;
    if (f.type === "number" && f.name === "price") r.positive = true;
    if (Object.keys(r).length) acc[f.name] = r;
    return acc;
  }, {});

  const { errors, touched, touch, touchAll, clearErrors } = useValidation(rules);

  // Limpa erros quando o formulário é resetado (values voltam aos padrões)
  useEffect(() => {
    const isEmpty = Object.values(values).every((v) => v === "" || v === undefined);
    if (isEmpty) clearErrors();
  }, [values, clearErrors]);

  const handleSubmit = useCallback(
    (e) => {
      e.preventDefault();
      const valid = touchAll(values);
      if (!valid) return;
      onSubmit?.(values);
    },
    [values, touchAll, onSubmit]
  );

  const handleChange = useCallback(
    (name, value) => {
      onFieldChange?.(name, value);
      // Revalida enquanto o usuário digita (se o campo já foi tocado)
      if (touched[name]) touch(name, { ...values, [name]: value });
    },
    [onFieldChange, touched, touch, values]
  );

  const handleBlur = useCallback(
    (name) => {
      touch(name, values);
      onFieldBlur?.(name);
    },
    [touch, values, onFieldBlur]
  );

  return (
    <form
      onSubmit={handleSubmit}
      noValidate
      style={{ width: "100%" }}
    >
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(240px, 1fr))",
          gap: "var(--space-lg)",
          marginBottom: "var(--space-2xl)",
        }}
      >
        {fields.map((field) => {
          const fieldError = touched[field.name] ? errors[field.name] : undefined;
          const fieldSuccess =
            touched[field.name] && !errors[field.name] && values[field.name] !== "";

          // ── Textarea ─────────────────────────────────────────────────────
          if (field.type === "textarea") {
            return (
              <div
                key={field.name}
                style={{ gridColumn: "1 / -1" }}
              >
                <label
                  style={{
                    display: "block",
                    fontSize: 12,
                    fontWeight: 600,
                    color: fieldError ? "var(--color-danger)" : "var(--color-textSecondary)",
                    marginBottom: 6,
                    transition: "color 150ms",
                  }}
                >
                  {field.label}
                  {field.required && (
                    <span style={{ color: "var(--color-danger)", marginLeft: 3 }}>*</span>
                  )}
                </label>
                <textarea
                  name={field.name}
                  value={values[field.name] || ""}
                  placeholder={field.placeholder}
                  rows={field.rows || 3}
                  disabled={isSubmitting}
                  onChange={(e) => handleChange(field.name, e.target.value)}
                  onBlur={() => handleBlur(field.name)}
                  style={{
                    width: "100%",
                    padding: "10px 14px",
                    background: "var(--color-surface2)",
                    border: `1px solid ${fieldError ? "var(--color-danger)" : "var(--color-border2)"}`,
                    borderRadius: "var(--radius-md)",
                    color: "var(--color-text)",
                    fontFamily: "var(--font-body)",
                    fontSize: 14,
                    outline: "none",
                    resize: "vertical",
                    transition: "border-color 150ms, box-shadow 150ms",
                    boxShadow: fieldError ? "0 0 0 3px rgba(247,100,100,0.12)" : "none",
                  }}
                />
                {fieldError && (
                  <div
                    style={{
                      display: "flex", alignItems: "center", gap: 5,
                      fontSize: 11, color: "var(--color-danger)", marginTop: 5,
                      animation: "fadeIn .2s ease",
                    }}
                  >
                    <svg width="11" height="11" viewBox="0 0 12 12" fill="none">
                      <circle cx="6" cy="6" r="5" stroke="currentColor" strokeWidth="1.2"/>
                      <path d="M6 4v2.5" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
                      <circle cx="6" cy="8.5" r=".5" fill="currentColor"/>
                    </svg>
                    {fieldError}
                  </div>
                )}
              </div>
            );
          }

          // ── Select ────────────────────────────────────────────────────────
          if (field.type === "select") {
            return (
              <div key={field.name}>
                <label
                  style={{
                    display: "block",
                    fontSize: 12,
                    fontWeight: 600,
                    color: fieldError ? "var(--color-danger)" : "var(--color-textSecondary)",
                    marginBottom: 6,
                    transition: "color 150ms",
                  }}
                >
                  {field.label}
                  {field.required && (
                    <span style={{ color: "var(--color-danger)", marginLeft: 3 }}>*</span>
                  )}
                </label>
                <select
                  name={field.name}
                  value={values[field.name] || ""}
                  disabled={isSubmitting}
                  onChange={(e) => handleChange(field.name, e.target.value)}
                  onBlur={() => handleBlur(field.name)}
                  style={{
                    width: "100%",
                    padding: "10px 14px",
                    background: "var(--color-surface2)",
                    border: `1px solid ${fieldError ? "var(--color-danger)" : "var(--color-border2)"}`,
                    borderRadius: "var(--radius-md)",
                    color: values[field.name] ? "var(--color-text)" : "var(--color-textMuted)",
                    fontFamily: "var(--font-body)",
                    fontSize: 14,
                    outline: "none",
                    cursor: "pointer",
                    transition: "border-color 150ms",
                    boxShadow: fieldError ? "0 0 0 3px rgba(247,100,100,0.12)" : "none",
                  }}
                >
                  <option value="" disabled>Selecione...</option>
                  {(field.options || []).map((opt) => (
                    <option key={opt.value} value={opt.value}>
                      {opt.label}
                    </option>
                  ))}
                </select>
                {fieldError && (
                  <div
                    style={{
                      display: "flex", alignItems: "center", gap: 5,
                      fontSize: 11, color: "var(--color-danger)", marginTop: 5,
                      animation: "fadeIn .2s ease",
                    }}
                  >
                    <svg width="11" height="11" viewBox="0 0 12 12" fill="none">
                      <circle cx="6" cy="6" r="5" stroke="currentColor" strokeWidth="1.2"/>
                      <path d="M6 4v2.5" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
                      <circle cx="6" cy="8.5" r=".5" fill="currentColor"/>
                    </svg>
                    {fieldError}
                  </div>
                )}
              </div>
            );
          }

          // ── Input padrão ──────────────────────────────────────────────────
          return (
            <Input
              key={field.name}
              type={field.type || "text"}
              label={field.label}
              required={field.required}
              placeholder={field.placeholder}
              value={values[field.name] ?? ""}
              disabled={isSubmitting}
              error={!!fieldError}
              success={fieldSuccess}
              errorMessage={fieldError}
              hint={field.hint}
              maxLength={field.maxLength}
              showCount={field.showCount}
              onChange={(e) => handleChange(field.name, e.target.value)}
              onBlur={() => handleBlur(field.name)}
              style={{ marginBottom: 0 }}
            />
          );
        })}
      </div>

      {/* Ações */}
      <div
        style={{
          display: "flex",
          gap: "var(--space-md)",
          justifyContent: "flex-end",
          flexWrap: "wrap",
          paddingTop: "var(--space-lg)",
          borderTop: "1px solid var(--color-border)",
        }}
      >
        {onCancel && (
          <Button
            type="button"
            variant="secondary"
            onClick={onCancel}
            disabled={isSubmitting}
          >
            {cancelLabel}
          </Button>
        )}
        <Button
          type="submit"
          variant="primary"
          disabled={isSubmitting}
        >
          {isSubmitting ? (
            <span style={{ display: "flex", alignItems: "center", gap: 8 }}>
              <svg
                width="14" height="14" viewBox="0 0 16 16" fill="none"
                style={{ animation: "spin 0.8s linear infinite" }}
              >
                <circle cx="8" cy="8" r="6" stroke="rgba(255,255,255,0.3)" strokeWidth="1.5"/>
                <path d="M8 2a6 6 0 0 1 6 6" stroke="white" strokeWidth="1.5" strokeLinecap="round"/>
              </svg>
              Processando...
            </span>
          ) : submitLabel}
        </Button>
      </div>
    </form>
  );
});

DataForm.displayName = "DataForm";
export default DataForm;
