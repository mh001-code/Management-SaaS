import React, { memo, forwardRef, useState } from "react";

/**
 * Input
 *
 * Props extras em relação à versão anterior:
 *   showCount  — exibe contador caracteres restantes (requer maxLength)
 *   prefix     — ícone/texto antes do campo
 *   suffix     — ícone/texto depois do campo
 *   hint       — texto de dica abaixo, substituído pelo erro quando há erro
 */
const Input = memo(
  forwardRef(
    (
      {
        type = "text",
        placeholder = "",
        value = "",
        onChange = null,
        onBlur = null,
        onFocus = null,
        disabled = false,
        error = false,
        success = false,
        label = null,
        required = false,
        hint = null,
        errorMessage = null,
        showCount = false,
        maxLength,
        prefix = null,
        suffix = null,
        className = "",
        style = {},
        ...props
      },
      ref
    ) => {
      const [focused, setFocused] = useState(false);

      const hasError   = !!errorMessage || error;
      const hasSuccess = !hasError && success;

      const borderColor = hasError
        ? "var(--color-danger)"
        : hasSuccess
        ? "var(--color-success)"
        : focused
        ? "var(--color-primary)"
        : "var(--color-border2)";

      const boxShadow = hasError
        ? "0 0 0 3px rgba(247,100,100,0.12)"
        : hasSuccess
        ? "0 0 0 3px rgba(0,212,170,0.12)"
        : focused
        ? "0 0 0 3px rgba(124,106,247,0.12)"
        : "none";

      const remaining =
        showCount && maxLength !== undefined ? maxLength - String(value).length : null;

      return (
        <>
          <style>{`
            @keyframes shake {
              0%,100%{ transform:translateX(0) }
              20%    { transform:translateX(-4px) }
              40%    { transform:translateX(4px) }
              60%    { transform:translateX(-3px) }
              80%    { transform:translateX(3px) }
            }
            .inp-error-msg {
              display: flex; align-items: center; gap: 5px;
              font-size: 11px; color: var(--color-danger);
              margin-top: 5px;
              animation: fadeIn .2s ease;
            }
            .inp-hint {
              font-size: 11px; color: var(--color-textMuted);
              margin-top: 5px;
            }
            @keyframes fadeIn { from{opacity:0;transform:translateY(-3px)} to{opacity:1;transform:translateY(0)} }
          `}</style>

          <div
            className={`form-group ${className}`}
            style={{ marginBottom: 0, ...style }}
          >
            {/* Label */}
            {label && (
              <label
                style={{
                  display: "flex",
                  justifyContent: "space-between",
                  alignItems: "center",
                  fontSize: 12,
                  fontWeight: 600,
                  color: hasError
                    ? "var(--color-danger)"
                    : "var(--color-textSecondary)",
                  marginBottom: 6,
                  transition: "color 150ms",
                }}
              >
                <span>
                  {label}
                  {required && (
                    <span style={{ color: "var(--color-danger)", marginLeft: 3 }}>*</span>
                  )}
                </span>
                {remaining !== null && (
                  <span
                    style={{
                      fontWeight: 400,
                      color: remaining < 10 ? "var(--color-danger)" : "var(--color-textMuted)",
                    }}
                  >
                    {remaining}
                  </span>
                )}
              </label>
            )}

            {/* Wrapper com prefix/suffix */}
            <div style={{ position: "relative", display: "flex", alignItems: "center" }}>
              {prefix && (
                <div
                  style={{
                    position: "absolute",
                    left: 12,
                    color: "var(--color-textMuted)",
                    display: "flex",
                    alignItems: "center",
                    pointerEvents: "none",
                    fontSize: 14,
                  }}
                >
                  {prefix}
                </div>
              )}

              <input
                ref={ref}
                type={type}
                placeholder={placeholder}
                value={value}
                maxLength={maxLength}
                disabled={disabled}
                onChange={onChange}
                onFocus={(e) => { setFocused(true); onFocus?.(e); }}
                onBlur={(e) => { setFocused(false); onBlur?.(e); }}
                style={{
                  width: "100%",
                  padding: `10px ${suffix ? "38px" : "14px"} 10px ${prefix ? "38px" : "14px"}`,
                  background: disabled
                    ? "rgba(255,255,255,0.02)"
                    : "var(--color-surface2)",
                  border: `1px solid ${borderColor}`,
                  borderRadius: "var(--radius-md)",
                  color: "var(--color-text)",
                  fontFamily: "var(--font-body)",
                  fontSize: 14,
                  outline: "none",
                  boxShadow,
                  transition: "border-color 150ms, box-shadow 150ms",
                  cursor: disabled ? "not-allowed" : "text",
                  opacity: disabled ? 0.5 : 1,
                  animation: hasError ? "shake 0.35s ease" : "none",
                }}
                {...props}
              />

              {/* Ícone de status */}
              {(hasError || hasSuccess) && (
                <div
                  style={{
                    position: "absolute",
                    right: suffix ? 36 : 12,
                    display: "flex",
                    alignItems: "center",
                    pointerEvents: "none",
                  }}
                >
                  {hasError ? (
                    <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
                      <circle cx="8" cy="8" r="7" stroke="#F76464" strokeWidth="1.5"/>
                      <path d="M8 5v3.5" stroke="#F76464" strokeWidth="1.5" strokeLinecap="round"/>
                      <circle cx="8" cy="11" r=".75" fill="#F76464"/>
                    </svg>
                  ) : (
                    <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
                      <circle cx="8" cy="8" r="7" stroke="#00D4AA" strokeWidth="1.5"/>
                      <path d="M5 8l2 2 4-4" stroke="#00D4AA" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
                    </svg>
                  )}
                </div>
              )}

              {suffix && (
                <div
                  style={{
                    position: "absolute",
                    right: 12,
                    color: "var(--color-textMuted)",
                    display: "flex",
                    alignItems: "center",
                    pointerEvents: "none",
                    fontSize: 14,
                  }}
                >
                  {suffix}
                </div>
              )}
            </div>

            {/* Mensagem de erro animada */}
            {errorMessage && (
              <div className="inp-error-msg">
                <svg width="11" height="11" viewBox="0 0 12 12" fill="none">
                  <circle cx="6" cy="6" r="5" stroke="currentColor" strokeWidth="1.2"/>
                  <path d="M6 4v2.5" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
                  <circle cx="6" cy="8.5" r=".5" fill="currentColor"/>
                </svg>
                {errorMessage}
              </div>
            )}

            {/* Hint (só aparece se não há erro) */}
            {hint && !errorMessage && (
              <div className="inp-hint">{hint}</div>
            )}
          </div>
        </>
      );
    }
  )
);

Input.displayName = "Input";
export default Input;
