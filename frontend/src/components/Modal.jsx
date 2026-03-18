import React, { memo, useEffect } from "react";

/**
 * Modal Component
 * Suporta fechamento por ESC e clique no overlay
 */
const Modal = memo(({ isOpen, onClose, title = null, children, width = "500px" }) => {
  // Fecha com ESC
  useEffect(() => {
    if (!isOpen) return;
    const handleKeyDown = (e) => {
      if (e.key === "Escape") onClose?.();
    };
    document.addEventListener("keydown", handleKeyDown);
    return () => document.removeEventListener("keydown", handleKeyDown);
  }, [isOpen, onClose]);

  // Bloqueia scroll do body enquanto modal está aberto
  useEffect(() => {
    document.body.style.overflow = isOpen ? "hidden" : "";
    return () => { document.body.style.overflow = ""; };
  }, [isOpen]);

  if (!isOpen) return null;

  return (
    <>
      {/* Overlay */}
      <div
        onClick={onClose}
        style={{
          position: "fixed",
          inset: 0,
          background: "rgba(0,0,0,0.6)",
          backdropFilter: "blur(4px)",
          zIndex: "var(--z-backdrop)",
          animation: "fadeIn 200ms ease",
        }}
      />

      {/* Conteúdo */}
      <div
        style={{
          position: "fixed",
          top: "50%",
          left: "50%",
          transform: "translate(-50%, -50%)",
          width,
          maxWidth: "calc(100vw - 32px)",
          maxHeight: "calc(100vh - 64px)",
          overflowY: "auto",
          background: "var(--color-surface)",
          border: "1px solid var(--color-border)",
          borderRadius: "var(--radius-lg)",
          boxShadow: "var(--shadow-xl)",
          zIndex: "var(--z-modal)",
          animation: "fadeUp 200ms cubic-bezier(0.22,1,0.36,1)",
        }}
      >
        {/* Header */}
        {title && (
          <div
            style={{
              display: "flex",
              justifyContent: "space-between",
              alignItems: "center",
              padding: "var(--space-xl) var(--space-2xl)",
              borderBottom: "1px solid var(--color-border)",
            }}
          >
            <h3
              style={{
                margin: 0,
                fontSize: "var(--text-lg)",
                fontWeight: 700,
                color: "var(--color-text)",
                fontFamily: "var(--font-display)",
              }}
            >
              {title}
            </h3>
            <button
              onClick={onClose}
              style={{
                background: "none",
                border: "none",
                color: "var(--color-textMuted)",
                cursor: "pointer",
                fontSize: "20px",
                lineHeight: 1,
                padding: "4px",
                transition: "color 150ms ease",
              }}
              onMouseEnter={(e) => (e.target.style.color = "var(--color-text)")}
              onMouseLeave={(e) => (e.target.style.color = "var(--color-textMuted)")}
            >
              ✕
            </button>
          </div>
        )}

        {/* Body */}
        <div style={{ padding: "var(--space-2xl)" }}>
          {children}
        </div>
      </div>
    </>
  );
});

Modal.displayName = "Modal";

export default Modal;
