import React, { useState, useEffect } from "react";
import { NavLink, useLocation } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext";

const Icon = ({ d, size = 17 }) => (
  <svg width={size} height={size} viewBox="0 0 20 20" fill="none" style={{ flexShrink: 0 }}>
    <path d={d} stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
  </svg>
);

const ICONS = {
  dashboard: "M3 3h6v6H3zM11 3h6v6h-6zM3 11h6v6H3zM11 11h6v6h-6z",
  clients:   "M10 9a4 4 0 1 0 0-8 4 4 0 0 0 0 8zm-7 9a7 7 0 0 1 14 0",
  products:  "M4 4h12v3H4zM4 10h12v6H4z",
  orders:    "M4 5h12M4 10h12M4 15h7",
  users:     "M7 8a3 3 0 1 0 6 0 3 3 0 0 0-6 0M3 18a7 7 0 0 1 14 0",
  financial: "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 17h-2v-2h2v2zm2.07-7.75l-.9.92C13.45 12.9 13 13.5 13 15h-2v-.5c0-1.1.45-2.1 1.17-2.83l1.24-1.26c.37-.36.59-.86.59-1.41 0-1.1-.9-2-2-2s-2 .9-2 2H8c0-2.21 1.79-4 4-4s4 1.79 4 4c0 .88-.36 1.68-.93 2.25z",
  suppliers: "M17 9a4 4 0 1 1-8 0 4 4 0 0 1 8 0zM3 20a7 7 0 0 1 14 0M19 8v6M22 11h-6",
  logout:    "M7 3H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h3M13 14l4-4-4-4M7 10h10",
  menu:      "M3 5h14M3 10h14M3 15h14",
  close:     "M3 3l14 14M17 3L3 17",
  chevronR:  "M8 4l6 6-6 6",
  chevronL:  "M12 4L6 10l6 6",
};

const LINKS = [
  { name: "Dashboard", path: "/dashboard", icon: "dashboard" },
  { name: "Clientes",  path: "/clients",   icon: "clients"   },
  { name: "Produtos",  path: "/products",  icon: "products"  },
  { name: "Pedidos",   path: "/orders",    icon: "orders"    },
  { name: "Usuários",      path: "/users",      icon: "users"     },
  { name: "Financeiro",   path: "/financial",  icon: "financial"  },
  { name: "Fornecedores", path: "/suppliers",  icon: "suppliers" },
];

const SB_FULL = 240;
const SB_SLIM = 72;

// ─── Sidebar principal ────────────────────────────────────────────────────────
const Sidebar = () => {
  const { user, logout } = useAuth();
  const location = useLocation();
  const [collapsed, setCollapsed]   = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const [mounted, setMounted]       = useState(false);

  // Propaga a largura atual como CSS variable no <html>
  // O .app-main-layout usa margin-left: var(--sb-width) para acompanhar
  useEffect(() => {
    document.documentElement.style.setProperty(
      "--sb-width",
      `${collapsed ? SB_SLIM : SB_FULL}px`
    );
  }, [collapsed]);

  useEffect(() => {
    // Valor inicial
    document.documentElement.style.setProperty("--sb-width", `${SB_FULL}px`);
    const t = setTimeout(() => setMounted(true), 60);
    return () => clearTimeout(t);
  }, []);

  // Fecha mobile ao navegar
  useEffect(() => { setMobileOpen(false); }, [location.pathname]);

  const handleLogout = () => {
    if (window.confirm("Deseja sair do sistema?")) logout();
  };

  const handleToggle = () => setCollapsed(c => !c);

  return (
    <>
      <style>{`
        @keyframes sbIn {
          from { opacity:0; transform:translateX(-8px); }
          to   { opacity:1; transform:translateX(0); }
        }
        /* Tooltip: aparece ao hover no pai */
        .sb-has-tooltip:hover .sb-tooltip { opacity:1 !important; }

        /* Desktop */
        .sb-desktop {
          position:fixed; left:0; top:0; height:100vh; z-index:20;
          display:flex; flex-direction:column;
          background:#13131A;
          border-right:1px solid rgba(255,255,255,0.06);
          overflow:hidden;
          transition:width 260ms cubic-bezier(0.4,0,0.2,1);
        }
        @media (max-width:768px) { .sb-desktop { display:none !important; } }

        /* Hamburger mobile */
        .sb-ham {
          position:fixed; top:14px; left:14px; z-index:50;
          width:36px; height:36px; border-radius:9px;
          border:1px solid rgba(255,255,255,0.1);
          background:#13131A; color:rgba(240,240,248,0.65);
          display:none; align-items:center; justify-content:center;
          cursor:pointer; transition:background 150ms, color 150ms;
        }
        .sb-ham:hover { background:#1A1A24; color:#F0F0F8; }
        @media (max-width:768px) { .sb-ham { display:flex; } }

        /* Mobile panel */
        .sb-mobile-panel {
          position:fixed; top:0; left:0; height:100%; width:240px; z-index:40;
          background:#13131A;
          border-right:1px solid rgba(255,255,255,0.06);
          display:flex; flex-direction:column;
          transition:transform 280ms cubic-bezier(0.4,0,0.2,1);
        }
        .sb-overlay {
          position:fixed; inset:0; z-index:30;
          background:rgba(0,0,0,0.55);
          backdrop-filter:blur(3px);
        }

        /* FIX BUG 2 — conteúdo acompanha a largura da sidebar */
        .app-main-layout {
          margin-left: var(--sb-width, 240px) !important;
          transition: margin-left 260ms cubic-bezier(0.4,0,0.2,1);
        }
        @media (max-width:768px) {
          .app-main-layout { margin-left: 0 !important; }
        }
      `}</style>

      {/* Hamburger mobile (só aparece quando o painel está fechado) */}
      {!mobileOpen && (
        <button className="sb-ham" onClick={() => setMobileOpen(true)} aria-label="Abrir menu">
          <Icon d={ICONS.menu} size={18} />
        </button>
      )}

      {/* Overlay + painel mobile */}
      {mobileOpen && (
        <>
          <div className="sb-overlay" onClick={() => setMobileOpen(false)} />
          <div className="sb-mobile-panel">
            <SidebarInner
              user={user}
              collapsed={false}
              isMobile
              mounted={mounted}
              onToggle={() => setMobileOpen(false)}
              onLogout={handleLogout}
            />
          </div>
        </>
      )}

      {/* Sidebar desktop */}
      <aside
        className="sb-desktop sidebar-desktop"
        style={{ width: collapsed ? SB_SLIM : SB_FULL }}
        aria-label="Navegação principal"
      >
        <SidebarInner
          user={user}
          collapsed={collapsed}
          isMobile={false}
          mounted={mounted}
          onToggle={handleToggle}
          onLogout={handleLogout}
        />
      </aside>
    </>
  );
};

// ─── Conteúdo interno ─────────────────────────────────────────────────────────
const SidebarInner = ({ user, collapsed, isMobile, mounted, onToggle, onLogout }) => {
  const location  = useLocation();
  const show      = !collapsed || isMobile;   // texto e labels visíveis?
  const initials  = user?.email?.[0]?.toUpperCase() ?? "U";

  return (
    <>
      {/* ── Header ── */}
      <div style={{
        display: "flex", alignItems: "center", gap: 10,
        padding: "0 12px", minHeight: 64, flexShrink: 0,
        borderBottom: "1px solid rgba(255,255,255,0.06)",
      }}>
        {/* Logo mark — sempre visível, é ele que serve de âncora no modo slim */}
        <div style={{
          width: 32, height: 32, borderRadius: 9, flexShrink: 0,
          background: "linear-gradient(135deg,#7C6AF7,#5B4DD4)",
          display: "flex", alignItems: "center", justifyContent: "center",
          fontSize: 13, fontWeight: 800, color: "#fff",
          boxShadow: "0 4px 12px rgba(124,106,247,0.3)",
          fontFamily: "'Space Grotesk',sans-serif",
        }}>M</div>

        {/* Nome — some com transição */}
        <span style={{
          fontSize: 15, fontWeight: 700, color: "#F0F0F8",
          letterSpacing: "-0.4px", whiteSpace: "nowrap", overflow: "hidden",
          fontFamily: "'Space Grotesk',sans-serif",
          maxWidth: show ? 140 : 0,
          opacity: show ? 1 : 0,
          transition: "max-width 260ms ease, opacity 180ms ease",
        }}>
          ManageSaaS
        </span>

        {/* Botão toggle — SEMPRE visível e clicável (FIX BUG 1) */}
        <button
          onClick={onToggle}
          aria-label={isMobile ? "Fechar menu" : collapsed ? "Expandir sidebar" : "Colapsar sidebar"}
          title={isMobile ? "Fechar" : collapsed ? "Expandir" : "Colapsar"}
          style={{
            marginLeft: "auto", flexShrink: 0,
            width: 30, height: 30, borderRadius: 8,
            border: "1px solid rgba(255,255,255,0.08)",
            background: "rgba(255,255,255,0.03)",
            color: "rgba(240,240,248,0.4)", cursor: "pointer",
            display: "flex", alignItems: "center", justifyContent: "center",
            transition: "background 150ms, color 150ms, border-color 150ms",
          }}
          onMouseEnter={e => {
            e.currentTarget.style.background = "rgba(124,106,247,0.15)";
            e.currentTarget.style.borderColor = "rgba(124,106,247,0.3)";
            e.currentTarget.style.color = "#7C6AF7";
          }}
          onMouseLeave={e => {
            e.currentTarget.style.background = "rgba(255,255,255,0.03)";
            e.currentTarget.style.borderColor = "rgba(255,255,255,0.08)";
            e.currentTarget.style.color = "rgba(240,240,248,0.4)";
          }}
        >
          {isMobile ? (
            <Icon d={ICONS.close} size={14} />
          ) : (
            /* Aponta para a direita quando colapsado (expandir), para esquerda quando expandido (colapsar) */
            <Icon d={collapsed ? ICONS.chevronR : ICONS.chevronL} size={14} />
          )}
        </button>
      </div>

      {/* ── Nav ── */}
      <nav style={{ flex: 1, padding: "10px 8px", overflowY: "auto", overflowX: "hidden" }}>
        {show && (
          <div style={{
            fontSize: 10, fontWeight: 600,
            color: "rgba(240,240,248,0.2)",
            textTransform: "uppercase", letterSpacing: "1px",
            padding: "4px 8px 8px",
          }}>
            Menu
          </div>
        )}

        {LINKS.map((link, i) => {
          const isActive =
            link.path === "/dashboard"
              ? location.pathname === "/" || location.pathname === "/dashboard"
              : location.pathname.startsWith(link.path);

          return (
            <NavLink
              key={link.path}
              to={link.path}
              aria-current={isActive ? "page" : undefined}
              className="sb-has-tooltip"
              style={{
                display: "flex", alignItems: "center", gap: 10,
                padding: "9px 10px", borderRadius: 9,
                textDecoration: "none", marginBottom: 2,
                color: isActive ? "#7C6AF7" : "rgba(240,240,248,0.45)",
                fontFamily: "'Space Grotesk',sans-serif",
                fontSize: 13, fontWeight: isActive ? 600 : 500,
                background: isActive ? "rgba(124,106,247,0.14)" : "transparent",
                borderLeft: isActive ? "3px solid #7C6AF7" : "3px solid transparent",
                position: "relative", whiteSpace: "nowrap",
                transition: "background 150ms, color 150ms, transform 150ms",
                animation: mounted
                  ? `sbIn .35s cubic-bezier(0.22,1,0.36,1) ${i * 45}ms both`
                  : "none",
              }}
              onMouseEnter={e => {
                if (!isActive) {
                  e.currentTarget.style.background = "rgba(124,106,247,0.07)";
                  e.currentTarget.style.color = "rgba(240,240,248,0.8)";
                  e.currentTarget.style.transform = "translateX(2px)";
                }
              }}
              onMouseLeave={e => {
                if (!isActive) {
                  e.currentTarget.style.background = "transparent";
                  e.currentTarget.style.color = "rgba(240,240,248,0.45)";
                  e.currentTarget.style.transform = "translateX(0)";
                }
              }}
            >
              <div style={{ width: 20, height: 20, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
                <Icon d={ICONS[link.icon]} size={17} />
              </div>

              <span style={{
                overflow: "hidden",
                maxWidth: show ? 150 : 0,
                opacity: show ? 1 : 0,
                transition: "max-width 260ms ease, opacity 180ms ease",
              }}>
                {link.name}
              </span>

              {/* Tooltip no modo slim (desktop colapsado) */}
              {!isMobile && collapsed && (
                <span
                  className="sb-tooltip"
                  style={{
                    position: "absolute", left: "calc(100% + 10px)", top: "50%",
                    transform: "translateY(-50%)", zIndex: 200,
                    background: "#1E1E2E", border: "1px solid rgba(255,255,255,0.12)",
                    borderRadius: 7, padding: "5px 11px",
                    fontSize: 12, fontWeight: 600, color: "#F0F0F8",
                    whiteSpace: "nowrap", pointerEvents: "none",
                    opacity: 0, transition: "opacity 150ms",
                    boxShadow: "0 4px 16px rgba(0,0,0,0.5)",
                  }}
                >
                  {link.name}
                </span>
              )}
            </NavLink>
          );
        })}
      </nav>

      {/* ── Footer ── */}
      <div style={{
        padding: "10px 8px",
        borderTop: "1px solid rgba(255,255,255,0.06)",
        flexShrink: 0,
      }}>
        {/* Info usuário */}
        <div style={{
          display: "flex", alignItems: "center", gap: 10,
          padding: "8px 10px", borderRadius: 9, marginBottom: 2, overflow: "hidden",
        }}>
          <div style={{
            width: 30, height: 30, borderRadius: 8, flexShrink: 0,
            background: "rgba(124,106,247,0.18)",
            border: "1px solid rgba(124,106,247,0.28)",
            color: "#7C6AF7", fontSize: 12, fontWeight: 700,
            display: "flex", alignItems: "center", justifyContent: "center",
            fontFamily: "'Space Grotesk',sans-serif",
          }}>
            {initials}
          </div>
          <div style={{
            minWidth: 0, overflow: "hidden",
            maxWidth: show ? 148 : 0,
            opacity: show ? 1 : 0,
            transition: "max-width 260ms ease, opacity 180ms ease",
          }}>
            <div style={{
              fontSize: 12, fontWeight: 600, color: "#F0F0F8",
              whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis",
              fontFamily: "'Space Grotesk',sans-serif",
            }}>
              {user?.email ?? "—"}
            </div>
            <div style={{ fontSize: 10, color: "rgba(240,240,248,0.3)", textTransform: "capitalize" }}>
              {user?.role ?? "—"}
            </div>
          </div>
        </div>

        {/* Botão logout */}
        <button
          onClick={onLogout}
          className="sb-has-tooltip"
          style={{
            display: "flex", alignItems: "center", gap: 10,
            padding: "9px 10px", borderRadius: 9,
            border: "none", background: "transparent", width: "100%",
            color: "rgba(247,100,100,0.5)",
            fontSize: 13, fontWeight: 500, fontFamily: "'Space Grotesk',sans-serif",
            cursor: "pointer", textAlign: "left", whiteSpace: "nowrap",
            transition: "background 150ms, color 150ms",
            position: "relative",
          }}
          onMouseEnter={e => {
            e.currentTarget.style.background = "rgba(247,100,100,0.08)";
            e.currentTarget.style.color = "#F76464";
          }}
          onMouseLeave={e => {
            e.currentTarget.style.background = "transparent";
            e.currentTarget.style.color = "rgba(247,100,100,0.5)";
          }}
        >
          <div style={{ width: 20, height: 20, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
            <Icon d={ICONS.logout} size={17} />
          </div>
          <span style={{
            maxWidth: show ? 150 : 0, opacity: show ? 1 : 0, overflow: "hidden",
            transition: "max-width 260ms ease, opacity 180ms ease",
          }}>
            Sair
          </span>
          {!isMobile && collapsed && (
            <span
              className="sb-tooltip"
              style={{
                position: "absolute", left: "calc(100% + 10px)", top: "50%",
                transform: "translateY(-50%)", zIndex: 200,
                background: "#1E1E2E", border: "1px solid rgba(255,255,255,0.12)",
                borderRadius: 7, padding: "5px 11px",
                fontSize: 12, fontWeight: 600, color: "#F76464",
                whiteSpace: "nowrap", pointerEvents: "none",
                opacity: 0, transition: "opacity 150ms",
                boxShadow: "0 4px 16px rgba(0,0,0,0.5)",
              }}
            >
              Sair
            </span>
          )}
        </button>
      </div>
    </>
  );
};

export default Sidebar;
