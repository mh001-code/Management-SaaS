import React, { useState, useEffect, useCallback, useRef } from "react";
import notificationService from "../services/notificationService";

const ICONS = {
  success: (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
      <circle cx="8" cy="8" r="7" stroke="currentColor" strokeWidth="1.5"/>
      <path d="M5 8l2 2 4-4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  ),
  error: (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
      <circle cx="8" cy="8" r="7" stroke="currentColor" strokeWidth="1.5"/>
      <path d="M5.5 5.5l5 5M10.5 5.5l-5 5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
    </svg>
  ),
  warning: (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
      <path d="M8 2L14.5 13H1.5L8 2Z" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round"/>
      <path d="M8 6v3.5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
      <circle cx="8" cy="11.5" r="0.75" fill="currentColor"/>
    </svg>
  ),
  info: (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
      <circle cx="8" cy="8" r="7" stroke="currentColor" strokeWidth="1.5"/>
      <path d="M8 7v4.5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
      <circle cx="8" cy="4.5" r="0.75" fill="currentColor"/>
    </svg>
  ),
  loading: (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none" style={{ animation: "toast-spin 0.8s linear infinite" }}>
      <circle cx="8" cy="8" r="6" stroke="currentColor" strokeWidth="1.5" strokeOpacity="0.3"/>
      <path d="M8 2a6 6 0 0 1 6 6" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
    </svg>
  ),
};

const STYLES = {
  success: {
    border: "rgba(34, 197, 94, 0.3)",
    icon: "#22c55e",
    bar: "#22c55e",
  },
  error: {
    border: "rgba(239, 68, 68, 0.3)",
    icon: "#ef4444",
    bar: "#ef4444",
  },
  warning: {
    border: "rgba(245, 158, 11, 0.3)",
    icon: "#f59e0b",
    bar: "#f59e0b",
  },
  info: {
    border: "rgba(79, 110, 247, 0.3)",
    icon: "#4f6ef7",
    bar: "#4f6ef7",
  },
  loading: {
    border: "rgba(167, 139, 250, 0.3)",
    icon: "#a78bfa",
    bar: "#a78bfa",
  },
};

const Toast = ({ toast, onRemove }) => {
  const [visible, setVisible] = useState(false);
  const [leaving, setLeaving] = useState(false);
  const [progress, setProgress] = useState(100);
  const timerRef = useRef(null);
  const startTimeRef = useRef(null);
  const style = STYLES[toast.type] || STYLES.info;

  const dismiss = useCallback(() => {
    setLeaving(true);
    clearInterval(timerRef.current);
    setTimeout(() => onRemove(toast.id), 300);
  }, [toast.id, onRemove]);

  useEffect(() => {
    // Entrada
    requestAnimationFrame(() => setVisible(true));

    // Auto-dismiss (duration=0 significa persistente, ex: loading)
    if (toast.duration > 0) {
      startTimeRef.current = Date.now();
      const interval = 30;
      timerRef.current = setInterval(() => {
        const elapsed = Date.now() - startTimeRef.current;
        const remaining = Math.max(0, 1 - elapsed / toast.duration);
        setProgress(remaining * 100);
        if (remaining <= 0) dismiss();
      }, interval);
    }

    return () => clearInterval(timerRef.current);
  }, [toast.duration, dismiss]);

  return (
    <>
      <style>{`
        @keyframes toast-in {
          from { opacity: 0; transform: translateY(12px) scale(0.97); }
          to   { opacity: 1; transform: translateY(0)    scale(1);    }
        }
        @keyframes toast-out {
          from { opacity: 1; transform: translateY(0)    scale(1);    max-height: 80px; margin-bottom: 8px; }
          to   { opacity: 0; transform: translateY(12px) scale(0.97); max-height: 0;   margin-bottom: 0;   }
        }
        @keyframes toast-spin {
          to { transform: rotate(360deg); }
        }
      `}</style>
      <div
        role="alert"
        aria-live="polite"
        style={{
          display: "flex",
          flexDirection: "column",
          background: "rgba(17, 17, 24, 0.92)",
          backdropFilter: "blur(12px)",
          WebkitBackdropFilter: "blur(12px)",
          border: `1px solid ${style.border}`,
          borderRadius: "10px",
          overflow: "hidden",
          boxShadow: "0 8px 32px rgba(0,0,0,0.4), 0 2px 8px rgba(0,0,0,0.2)",
          minWidth: "300px",
          maxWidth: "420px",
          marginBottom: "8px",
          animation: leaving
            ? "toast-out 0.3s cubic-bezier(0.4,0,1,1) forwards"
            : visible
            ? "toast-in 0.35s cubic-bezier(0.22,1,0.36,1) forwards"
            : "none",
          opacity: visible ? undefined : 0,
        }}
      >
        {/* Corpo */}
        <div
          style={{
            display: "flex",
            alignItems: "flex-start",
            gap: "12px",
            padding: "14px 16px",
          }}
        >
          {/* Ícone */}
          <span
            style={{
              color: style.icon,
              flexShrink: 0,
              marginTop: "1px",
              display: "flex",
            }}
          >
            {ICONS[toast.type]}
          </span>

          {/* Mensagem */}
          <span
            style={{
              flex: 1,
              fontSize: "13px",
              lineHeight: "1.5",
              color: "#e8e8f0",
              fontFamily: "'DM Sans', sans-serif",
              fontWeight: 500,
            }}
          >
            {toast.message}
          </span>

          {/* Botão fechar */}
          <button
            onClick={dismiss}
            aria-label="Fechar notificação"
            style={{
              background: "none",
              border: "none",
              color: "rgba(255,255,255,0.3)",
              cursor: "pointer",
              padding: "0",
              lineHeight: 1,
              flexShrink: 0,
              marginTop: "1px",
              transition: "color 150ms ease",
              display: "flex",
            }}
            onMouseEnter={(e) => (e.currentTarget.style.color = "rgba(255,255,255,0.8)")}
            onMouseLeave={(e) => (e.currentTarget.style.color = "rgba(255,255,255,0.3)")}
          >
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
              <path d="M2 2l10 10M12 2L2 12" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
            </svg>
          </button>
        </div>

        {/* Barra de progresso */}
        {toast.duration > 0 && (
          <div
            style={{
              height: "2px",
              background: "rgba(255,255,255,0.06)",
            }}
          >
            <div
              style={{
                height: "100%",
                width: `${progress}%`,
                background: style.bar,
                transition: "width 30ms linear",
                borderRadius: "0 1px 1px 0",
                opacity: 0.7,
              }}
            />
          </div>
        )}
      </div>
    </>
  );
};

const ToastContainer = () => {
  const [toasts, setToasts] = useState([]);

  useEffect(() => {
    const unsubscribe = notificationService.subscribe((notification) => {
      setToasts((prev) => {
        // Evita duplicatas seguidas da mesma mensagem
        const last = prev[prev.length - 1];
        if (last && last.message === notification.message && last.type === notification.type) {
          return prev;
        }
        return [...prev, notification];
      });
    });
    return unsubscribe;
  }, []);

  const handleRemove = useCallback((id) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  }, []);

  if (toasts.length === 0) return null;

  return (
    <>
      <style>{`
        .toast-container {
          position: fixed;
          bottom: 24px;
          right: 24px;
          z-index: 9999;
          display: flex;
          flex-direction: column;
          align-items: flex-end;
          pointer-events: none;
        }
        @media (max-width: 480px) {
          .toast-container {
            left: 8px;
            right: 8px;
            bottom: 16px;
            align-items: stretch;
          }
          .toast-container .toast-item {
            min-width: 0 !important;
            max-width: 100% !important;
            width: 100%;
          }
        }
      `}</style>
      <div aria-label="Notificações" className="toast-container">
        {toasts.map((toast) => (
          <div key={toast.id} className="toast-item" style={{ pointerEvents: "auto" }}>
            <Toast toast={toast} onRemove={handleRemove} />
          </div>
        ))}
      </div>
    </>
  );
};

export default ToastContainer;
