import React, { useState, useEffect, useRef } from "react";
import { useNavigate } from "react-router-dom";
import { useNotifications } from "../hooks/useNotifications";

const TYPE_COLOR = {
  danger:  { bg: "rgba(247,100,100,0.1)",  border: "rgba(247,100,100,0.2)",  text: "#F76464", dot: "#F76464" },
  warning: { bg: "rgba(247,145,106,0.1)",  border: "rgba(247,145,106,0.2)",  text: "#F7916A", dot: "#F7916A" },
  info:    { bg: "rgba(124,106,247,0.1)",  border: "rgba(124,106,247,0.2)",  text: "#7C6AF7", dot: "#7C6AF7" },
};

const BellIcon = ({ hasDanger }) => (
  <svg width="17" height="17" viewBox="0 0 20 20" fill="none">
    <path
      d="M10 2a6 6 0 0 0-6 6v3l-1.5 2.5h15L16 11V8a6 6 0 0 0-6-6z"
      stroke="currentColor" strokeWidth="1.4" strokeLinejoin="round"
      fill={hasDanger ? "rgba(247,100,100,0.15)" : "none"}
    />
    <path d="M8 15.5a2 2 0 0 0 4 0" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round"/>
  </svg>
);

export default function NotificationBell({ collapsed }) {
  const { alerts, total, loading, refresh, lastUpdate } = useNotifications();
  const [open, setOpen] = useState(false);
  const ref             = useRef(null);
  const navigate        = useNavigate();

  // Fecha ao clicar fora
  useEffect(() => {
    const handler = (e) => { if (ref.current && !ref.current.contains(e.target)) setOpen(false); };
    document.addEventListener("mousedown", handler);
    return () => document.removeEventListener("mousedown", handler);
  }, []);

  const hasDanger = alerts.some((a) => a.type === "danger");

  const handleLink = (link) => {
    setOpen(false);
    navigate(link);
  };

  return (
    <div ref={ref} style={{ position: "relative" }}>
      {/* Botão sino */}
      <button
        onClick={() => setOpen((o) => !o)}
        title="Notificações"
        style={{
          display: "flex", alignItems: "center", gap: 8,
          padding: "8px 10px", borderRadius: 9, width: "100%",
          border: "none", background: open ? "rgba(124,106,247,0.08)" : "transparent",
          color: hasDanger ? "#F76464" : total > 0 ? "#F7916A" : "rgba(240,240,248,0.4)",
          cursor: "pointer", transition: "background 150ms, color 150ms",
          fontFamily: "'Space Grotesk', sans-serif", fontSize: 13, fontWeight: 500,
          position: "relative",
        }}
        onMouseEnter={(e) => { e.currentTarget.style.background = "rgba(124,106,247,0.07)"; e.currentTarget.style.color = "#F0F0F8"; }}
        onMouseLeave={(e) => { e.currentTarget.style.background = open ? "rgba(124,106,247,0.08)" : "transparent"; e.currentTarget.style.color = hasDanger ? "#F76464" : total > 0 ? "#F7916A" : "rgba(240,240,248,0.4)"; }}
      >
        {/* Ícone */}
        <div style={{ width: 20, height: 20, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0, position: "relative" }}>
          <BellIcon hasDanger={hasDanger} />
          {total > 0 && (
            <span style={{
              position: "absolute", top: -4, right: -4,
              width: 14, height: 14, borderRadius: "50%",
              background: hasDanger ? "#F76464" : "#F7916A",
              color: "#fff", fontSize: 8, fontWeight: 700,
              display: "flex", alignItems: "center", justifyContent: "center",
              border: "1.5px solid #13131A",
            }}>
              {total > 9 ? "9+" : total}
            </span>
          )}
        </div>

        {/* Label — some no modo slim */}
        <span style={{
          overflow: "hidden",
          maxWidth: collapsed ? 0 : 150,
          opacity: collapsed ? 0 : 1,
          transition: "max-width 260ms ease, opacity 180ms ease",
          whiteSpace: "nowrap",
        }}>
          Notificações
        </span>

        {/* Badge inline no modo expandido */}
        {!collapsed && total > 0 && (
          <span style={{
            marginLeft: "auto", fontSize: 10, fontWeight: 700,
            padding: "2px 6px", borderRadius: 99,
            background: hasDanger ? "rgba(247,100,100,0.15)" : "rgba(247,145,106,0.15)",
            color: hasDanger ? "#F76464" : "#F7916A",
          }}>
            {total}
          </span>
        )}
      </button>

      {/* Dropdown */}
      {open && (
        <div className="notif-dropdown" style={{
          position: "fixed",
          left: collapsed ? 80 : 248,
          bottom: 60,
          width: 340,
          background: "var(--color-surface)",
          border: "1px solid var(--color-border2)",
          borderRadius: 14,
          boxShadow: "0 16px 48px rgba(0,0,0,0.6)",
          zIndex: 9999,
          overflow: "hidden",
          animation: "fadeUp 200ms cubic-bezier(0.22,1,0.36,1)",
        }}>
          <style>{`
            @keyframes fadeUp{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
            @media(max-width:768px){
              .notif-dropdown{
                left: 8px !important;
                right: 8px !important;
                width: auto !important;
                bottom: 8px !important;
              }
            }
          `}</style>

          {/* Header do dropdown */}
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between",
            padding: "14px 16px", borderBottom: "1px solid var(--color-border)" }}>
            <span style={{ fontSize: 13, fontWeight: 600, color: "var(--color-text)" }}>Notificações</span>
            <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
              {lastUpdate && (
                <span style={{ fontSize: 10, color: "var(--color-textMuted)" }}>
                  {lastUpdate.toLocaleTimeString("pt-BR", { hour: "2-digit", minute: "2-digit" })}
                </span>
              )}
              <button onClick={refresh} title="Atualizar" style={{
                background: "none", border: "none", color: "var(--color-textMuted)",
                cursor: "pointer", fontSize: 14, padding: 2,
              }}>↻</button>
            </div>
          </div>

          {/* Conteúdo */}
          <div style={{ maxHeight: 420, overflowY: "auto" }}>
            {loading ? (
              <div style={{ padding: 24, textAlign: "center", color: "var(--color-textMuted)", fontSize: 13 }}>
                Carregando...
              </div>
            ) : alerts.length === 0 ? (
              <div style={{ padding: 32, textAlign: "center" }}>
                <div style={{ fontSize: 28, marginBottom: 8 }}>✅</div>
                <div style={{ fontSize: 13, color: "var(--color-textMuted)", fontWeight: 500 }}>
                  Tudo em ordem!
                </div>
                <div style={{ fontSize: 11, color: "var(--color-textMuted)", marginTop: 4 }}>
                  Nenhum alerta no momento
                </div>
              </div>
            ) : (
              alerts.map((alert) => {
                const c = TYPE_COLOR[alert.type] ?? TYPE_COLOR.info;
                return (
                  <div key={alert.id} style={{
                    padding: "12px 16px",
                    borderBottom: "1px solid var(--color-border)",
                    background: "transparent",
                    transition: "background 150ms",
                  }}
                    onMouseEnter={(e) => e.currentTarget.style.background = "rgba(0,0,0,0.02)"}
                    onMouseLeave={(e) => e.currentTarget.style.background = "transparent"}
                  >
                    {/* Cabeçalho do alerta */}
                    <div style={{ display: "flex", alignItems: "flex-start", gap: 10, marginBottom: 6 }}>
                      <span style={{ fontSize: 14, flexShrink: 0, marginTop: 1 }}>{alert.icon}</span>
                      <div style={{ flex: 1, minWidth: 0 }}>
                        <div style={{ fontSize: 12, fontWeight: 600, color: c.text }}>
                          {alert.title}
                        </div>
                        {alert.subtitle && (
                          <div style={{ fontSize: 11, color: "var(--color-textMuted)", marginTop: 2 }}>
                            {alert.subtitle}
                          </div>
                        )}
                      </div>
                      <span style={{ fontSize: 10, padding: "2px 7px", borderRadius: 99,
                        background: c.bg, color: c.text, border: `1px solid ${c.border}`,
                        flexShrink: 0, fontWeight: 600 }}>
                        {alert.category}
                      </span>
                    </div>

                    {/* Lista de itens */}
                    {alert.items?.length > 0 && (
                      <div style={{ marginLeft: 24, marginBottom: 8 }}>
                        {alert.items.map((item, i) => (
                          <div key={i} style={{ display: "flex", alignItems: "center", gap: 6,
                            fontSize: 11, color: "var(--color-textMuted)", marginTop: 3 }}>
                            <div style={{ width: 4, height: 4, borderRadius: "50%",
                              background: c.dot, flexShrink: 0 }} />
                            <span style={{ overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                              {item}
                            </span>
                          </div>
                        ))}
                        {alert.items.length === 5 && (
                          <div style={{ fontSize: 10, color: "var(--color-textMuted)", marginTop: 4, marginLeft: 10 }}>
                            e mais...
                          </div>
                        )}
                      </div>
                    )}

                    {/* Link de ação */}
                    <button onClick={() => handleLink(alert.link)} style={{
                      marginLeft: 24, background: "none", border: "none",
                      color: c.text, fontSize: 11, fontWeight: 600,
                      cursor: "pointer", padding: 0, fontFamily: "inherit",
                      textDecoration: "underline",
                    }}>
                      {alert.linkLabel} →
                    </button>
                  </div>
                );
              })
            )}
          </div>

          {/* Footer */}
          {alerts.length > 0 && (
            <div style={{ padding: "10px 16px", borderTop: "1px solid var(--color-border)",
              textAlign: "center" }}>
              <span style={{ fontSize: 11, color: "var(--color-textMuted)" }}>
                Atualiza automaticamente a cada 5 minutos
              </span>
            </div>
          )}
        </div>
      )}
    </div>
  );
}