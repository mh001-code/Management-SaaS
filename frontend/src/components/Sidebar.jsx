import React, { useState, useEffect } from "react";
import { NavLink, useLocation } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext";
import { useTheme } from "../contexts/ThemeContext";
import NotificationBell from "./NotificationBell";

const Icon = ({ d, size = 17 }) => (
  <svg width={size} height={size} viewBox="0 0 20 20" fill="none" style={{ flexShrink: 0 }}>
    <path d={d} stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
  </svg>
);

const ICONS = {
  dashboard:      "M3 3h6v6H3zM11 3h6v6h-6zM3 11h6v6H3zM11 11h6v6h-6z",
  clients:        "M10 9a4 4 0 1 0 0-8 4 4 0 0 0 0 8zm-7 9a7 7 0 0 1 14 0",
  products:       "M4 4h12v3H4zM4 10h12v6H4z",
  orders:         "M4 5h12M4 10h12M4 15h7",
  users:          "M7 8a3 3 0 1 0 6 0 3 3 0 0 0-6 0M3 18a7 7 0 0 1 14 0",
  reports:        "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8l-6-6zm-1 1.5L18.5 9H13V3.5zM8 13h8v1.5H8V13zm0 3h8v1.5H8V16zm0-6h3v1.5H8V10z",
  financial:      "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 17h-2v-2h2v2zm2.07-7.75l-.9.92C13.45 12.9 13 13.5 13 15h-2v-.5c0-1.1.45-2.1 1.17-2.83l1.24-1.26c.37-.36.59-.86.59-1.41 0-1.1-.9-2-2-2s-2 .9-2 2H8c0-2.21 1.79-4 4-4s4 1.79 4 4c0 .88-.36 1.68-.93 2.25z",
  purchaseOrders: "M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 5a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2M9 5a2 2 0 0 0 2-2h2a2 2 0 0 0 2 2m-3 9l2 2 4-4",
  suppliers:      "M17 9a4 4 0 1 1-8 0 4 4 0 0 1 8 0zM3 20a7 7 0 0 1 14 0M19 8v6M22 11h-6",
  logout:         "M7 3H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h3M13 14l4-4-4-4M7 10h10",
  menu:           "M3 5h14M3 10h14M3 15h14",
  close:          "M3 3l14 14M17 3L3 17",
  chevronR:       "M8 4l6 6-6 6",
  chevronL:       "M12 4L6 10l6 6",
};

const LINKS = [
  { name: "Dashboard",         path: "/dashboard",       icon: "dashboard"      },
  { name: "Clientes",          path: "/clients",         icon: "clients"        },
  { name: "Produtos",          path: "/products",        icon: "products"       },
  { name: "Pedidos",           path: "/orders",          icon: "orders"         },
  { name: "Usuários",          path: "/users",           icon: "users"          },
  { name: "Relatórios",        path: "/reports",         icon: "reports"        },
  { name: "Financeiro",        path: "/financial",       icon: "financial"      },
  { name: "Fornecedores",      path: "/suppliers",       icon: "suppliers"      },
  { name: "Pedidos de Compra", path: "/purchase-orders", icon: "purchaseOrders" },
];

const SB_FULL = 240;
const SB_SLIM = 72;

const Sidebar = () => {
  const { user, logout } = useAuth();
  const location = useLocation();
  const [collapsed, setCollapsed]   = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const [mounted, setMounted]       = useState(false);

  useEffect(() => {
    document.documentElement.style.setProperty("--sb-width", `${collapsed ? SB_SLIM : SB_FULL}px`);
  }, [collapsed]);

  useEffect(() => {
    document.documentElement.style.setProperty("--sb-width", `${SB_FULL}px`);
    const t = setTimeout(() => setMounted(true), 60);
    return () => clearTimeout(t);
  }, []);

  useEffect(() => { setMobileOpen(false); }, [location.pathname]);

  const handleLogout = () => { if (window.confirm("Deseja sair do sistema?")) logout(); };
  const handleToggle = () => setCollapsed(c => !c);

  return (
    <>
      <style>{`
        @keyframes sbIn { from{opacity:0;transform:translateX(-8px)} to{opacity:1;transform:translateX(0)} }
        .sb-has-tooltip:hover .sb-tooltip { opacity:1 !important; }

        .sb-desktop {
          position:fixed; left:0; top:0; height:100vh; z-index:20;
          display:flex; flex-direction:column;
          background:var(--color-surface);
          border-right:1px solid var(--color-border);
          transition:width 260ms cubic-bezier(0.4,0,0.2,1);
        }
        @media(max-width:768px){ .sb-desktop{ display:none !important; } }

        .sb-ham {
          position:fixed; top:14px; left:14px; z-index:50;
          width:36px; height:36px; border-radius:9px;
          border:1px solid var(--color-border2);
          background:var(--color-surface); color:var(--color-textSecondary);
          display:none; align-items:center; justify-content:center;
          cursor:pointer; transition:background 150ms,color 150ms;
        }
        .sb-ham:hover{ background:var(--color-surface2); color:var(--color-text); }
        @media(max-width:768px){ .sb-ham{ display:flex; } }

        .sb-mobile-panel {
          position:fixed; top:0; left:0; height:100%; width:240px; z-index:40;
          background:var(--color-surface);
          border-right:1px solid var(--color-border);
          display:flex; flex-direction:column;
          transition:transform 280ms cubic-bezier(0.4,0,0.2,1);
        }
        .sb-overlay {
          position:fixed; inset:0; z-index:30;
          background:rgba(0,0,0,0.55); backdrop-filter:blur(3px);
        }
        .app-main-layout {
          margin-left:var(--sb-width,240px) !important;
          transition:margin-left 260ms cubic-bezier(0.4,0,0.2,1);
        }
        @media(max-width:768px){ .app-main-layout{ margin-left:0 !important; } }

        .sb-navlink {
          display:flex; align-items:center; gap:10px;
          padding:9px 10px; border-radius:9px; margin-bottom:2px;
          text-decoration:none;
          font-family:'Space Grotesk',sans-serif; font-size:13px; font-weight:500;
          color:var(--color-textMuted);
          background:transparent; border-left:3px solid transparent;
          position:relative; white-space:nowrap;
          transition:background 150ms,color 150ms,transform 150ms;
        }
        .sb-navlink:hover { background:rgba(124,106,247,0.07); color:var(--color-textSecondary); transform:translateX(2px); }
        .sb-navlink.active { color:var(--color-primary); background:rgba(124,106,247,0.12); border-left-color:var(--color-primary); font-weight:600; }
        .sb-navlink.active:hover { transform:none; }

        .sb-tooltip {
          position:absolute; left:calc(100% + 10px); top:50%;
          transform:translateY(-50%); z-index:200;
          background:var(--color-surface2); border:1px solid var(--color-border2);
          border-radius:7px; padding:5px 11px;
          font-size:12px; font-weight:600; color:var(--color-text);
          white-space:nowrap; pointer-events:none;
          opacity:0; transition:opacity 150ms; box-shadow:var(--shadow-md);
        }
        .sb-footer-btn {
          display:flex; align-items:center; gap:8px;
          padding:8px 10px; border-radius:9px; width:100%;
          border:none; background:transparent; color:var(--color-textMuted);
          cursor:pointer; transition:background 150ms,color 150ms;
          font-family:'Space Grotesk',sans-serif; font-size:13px; font-weight:500;
          position:relative; text-align:left; white-space:nowrap;
        }
        .sb-footer-btn:hover { background:rgba(124,106,247,0.07); color:var(--color-text); }
        .sb-logout-btn {
          display:flex; align-items:center; gap:10px;
          padding:9px 10px; border-radius:9px;
          border:none; background:transparent; width:100%;
          color:var(--color-danger); opacity:0.55;
          font-size:13px; font-weight:500; font-family:'Space Grotesk',sans-serif;
          cursor:pointer; text-align:left; white-space:nowrap;
          transition:background 150ms,color 150ms,opacity 150ms; position:relative;
        }
        .sb-logout-btn:hover { background:rgba(247,100,100,0.08); opacity:1; }
      `}</style>

      {!mobileOpen && (
        <button className="sb-ham" onClick={() => setMobileOpen(true)} aria-label="Abrir menu">
          <Icon d={ICONS.menu} size={18} />
        </button>
      )}

      {mobileOpen && (
        <>
          <div className="sb-overlay" onClick={() => setMobileOpen(false)} />
          <div className="sb-mobile-panel">
            <SidebarInner user={user} collapsed={false} isMobile mounted={mounted}
              onToggle={() => setMobileOpen(false)} onLogout={handleLogout} />
          </div>
        </>
      )}

      <aside className="sb-desktop sidebar-desktop"
        style={{ width: collapsed ? SB_SLIM : SB_FULL, overflow: "visible" }}
        aria-label="Navegação principal"
      >
        <SidebarInner user={user} collapsed={collapsed} isMobile={false}
          mounted={mounted} onToggle={handleToggle} onLogout={handleLogout} />

        <button onClick={handleToggle}
          aria-label={collapsed ? "Expandir sidebar" : "Colapsar sidebar"}
          style={{
            position:"absolute", top:18, right:-14,
            width:28, height:28, borderRadius:"50%",
            border:"1px solid var(--color-border2)",
            background:"var(--color-surface2)",
            color:"var(--color-textMuted)", cursor:"pointer",
            display:"flex", alignItems:"center", justifyContent:"center",
            boxShadow:"var(--shadow-md)",
            transition:"background 150ms,color 150ms,border-color 150ms", zIndex:30,
          }}
          onMouseEnter={e => { e.currentTarget.style.background="rgba(124,106,247,0.2)"; e.currentTarget.style.borderColor="rgba(124,106,247,0.4)"; e.currentTarget.style.color="var(--color-primary)"; }}
          onMouseLeave={e => { e.currentTarget.style.background="var(--color-surface2)"; e.currentTarget.style.borderColor="var(--color-border2)"; e.currentTarget.style.color="var(--color-textMuted)"; }}
        >
          <Icon d={collapsed ? ICONS.chevronR : ICONS.chevronL} size={13} />
        </button>
      </aside>
    </>
  );
};

const SidebarInner = ({ user, collapsed, isMobile, mounted, onToggle, onLogout }) => {
  const location = useLocation();
  const show     = !collapsed || isMobile;
  const initials = user?.email?.[0]?.toUpperCase() ?? "U";
  const { theme, toggleTheme } = useTheme();

  return (
    <div style={{ overflow:"hidden", display:"flex", flexDirection:"column", height:"100%" }}>

      {/* Header */}
      <div style={{
        display:"flex", alignItems:"center", gap:10,
        padding:"0 12px", minHeight:64, flexShrink:0,
        borderBottom:"1px solid var(--color-border)",
      }}>
        <div style={{
          width:32, height:32, borderRadius:9, flexShrink:0,
          background:"linear-gradient(135deg,var(--color-primary),var(--color-primaryDark))",
          display:"flex", alignItems:"center", justifyContent:"center",
          fontSize:13, fontWeight:800, color:"#fff",
          boxShadow:"0 4px 12px rgba(124,106,247,0.3)",
          fontFamily:"'Space Grotesk',sans-serif",
        }}>M</div>

        <span style={{
          fontSize:15, fontWeight:700, color:"var(--color-text)",
          letterSpacing:"-0.4px", whiteSpace:"nowrap", overflow:"hidden",
          fontFamily:"'Space Grotesk',sans-serif",
          maxWidth: show ? 140 : 0, opacity: show ? 1 : 0,
          transition:"max-width 260ms ease,opacity 180ms ease",
        }}>ManageSaaS</span>

        {isMobile && (
          <button onClick={onToggle} style={{
            marginLeft:"auto", flexShrink:0, width:30, height:30, borderRadius:8,
            border:"1px solid var(--color-border2)", background:"var(--color-surface2)",
            color:"var(--color-textMuted)", cursor:"pointer",
            display:"flex", alignItems:"center", justifyContent:"center",
            transition:"background 150ms,color 150ms",
          }}>
            <Icon d={ICONS.close} size={14} />
          </button>
        )}
      </div>

      {/* Nav */}
      <nav style={{ flex:1, padding:"10px 8px", overflowY:"auto", overflowX:"hidden" }}>
        {show && (
          <div style={{
            fontSize:10, fontWeight:600, color:"var(--color-textMuted)", opacity:0.5,
            textTransform:"uppercase", letterSpacing:"1px", padding:"4px 8px 8px",
          }}>Menu</div>
        )}
        {LINKS.map((link, i) => {
          const isActive = link.path === "/dashboard"
            ? location.pathname === "/" || location.pathname === "/dashboard"
            : location.pathname.startsWith(link.path);
          return (
            <NavLink key={link.path} to={link.path}
              aria-current={isActive ? "page" : undefined}
              className={`sb-has-tooltip sb-navlink${isActive ? " active" : ""}`}
              style={{ animation: mounted ? `sbIn .35s cubic-bezier(0.22,1,0.36,1) ${i*45}ms both` : "none" }}
            >
              <div style={{ width:20, height:20, display:"flex", alignItems:"center", justifyContent:"center", flexShrink:0 }}>
                <Icon d={ICONS[link.icon]} size={17} />
              </div>
              <span style={{ overflow:"hidden", maxWidth:show?150:0, opacity:show?1:0, transition:"max-width 260ms ease,opacity 180ms ease" }}>
                {link.name}
              </span>
              {!isMobile && collapsed && <span className="sb-tooltip">{link.name}</span>}
            </NavLink>
          );
        })}
      </nav>

      {/* Footer */}
      <div style={{ padding:"10px 8px", borderTop:"1px solid var(--color-border)", flexShrink:0 }}>
        {/* Info usuário */}
        <div style={{ display:"flex", alignItems:"center", gap:10, padding:"8px 10px", borderRadius:9, marginBottom:2, overflow:"hidden" }}>
          <div style={{
            width:30, height:30, borderRadius:8, flexShrink:0,
            background:"rgba(124,106,247,0.15)", border:"1px solid rgba(124,106,247,0.25)",
            color:"var(--color-primary)", fontSize:12, fontWeight:700,
            display:"flex", alignItems:"center", justifyContent:"center",
            fontFamily:"'Space Grotesk',sans-serif",
          }}>{initials}</div>
          <div style={{ minWidth:0, overflow:"hidden", maxWidth:show?148:0, opacity:show?1:0, transition:"max-width 260ms ease,opacity 180ms ease" }}>
            <div style={{ fontSize:12, fontWeight:600, color:"var(--color-text)", whiteSpace:"nowrap", overflow:"hidden", textOverflow:"ellipsis", fontFamily:"'Space Grotesk',sans-serif" }}>
              {user?.email ?? "—"}
            </div>
            <div style={{ fontSize:10, color:"var(--color-textMuted)", textTransform:"capitalize" }}>
              {user?.role ?? "—"}
            </div>
          </div>
        </div>

        {/* Tema */}
        <button onClick={toggleTheme} className="sb-has-tooltip sb-footer-btn"
          title={theme === "dark" ? "Mudar para tema claro" : "Mudar para tema escuro"}>
          <div style={{ width:20, height:20, display:"flex", alignItems:"center", justifyContent:"center", flexShrink:0, fontSize:15 }}>
            {theme === "dark" ? "☀️" : "🌙"}
          </div>
          <span style={{ overflow:"hidden", maxWidth:show?150:0, opacity:show?1:0, transition:"max-width 260ms ease,opacity 180ms ease", whiteSpace:"nowrap" }}>
            {theme === "dark" ? "Tema claro" : "Tema escuro"}
          </span>
          {!isMobile && collapsed && <span className="sb-tooltip">{theme === "dark" ? "Tema claro" : "Tema escuro"}</span>}
        </button>

        <NotificationBell collapsed={collapsed && !isMobile} />

        {/* Logout */}
        <button onClick={onLogout} className="sb-has-tooltip sb-logout-btn">
          <div style={{ width:20, height:20, display:"flex", alignItems:"center", justifyContent:"center", flexShrink:0 }}>
            <Icon d={ICONS.logout} size={17} />
          </div>
          <span style={{ maxWidth:show?150:0, opacity:show?1:0, overflow:"hidden", transition:"max-width 260ms ease,opacity 180ms ease" }}>Sair</span>
          {!isMobile && collapsed && <span className="sb-tooltip" style={{ color:"var(--color-danger)" }}>Sair</span>}
        </button>
      </div>
    </div>
  );
};

export default Sidebar;