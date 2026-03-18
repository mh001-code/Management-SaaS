import React, { useState } from "react";
import { NavLink } from "react-router-dom";
import { FaBars, FaTachometerAlt, FaUsers, FaBoxOpen, FaShoppingCart, FaUserShield, FaSignOutAlt } from "react-icons/fa";
import { useAuth } from "../contexts/AuthContext";

const Sidebar = () => {
  const [collapsed, setCollapsed] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const [showHamburger, setShowHamburger] = useState(true);
  const { user, logout } = useAuth();

  const links = [
    { name: "Dashboard", path: "/", icon: <FaTachometerAlt /> },
    { name: "Clientes", path: "/clients", icon: <FaUsers /> },
    { name: "Produtos", path: "/products", icon: <FaBoxOpen /> },
    { name: "Pedidos", path: "/orders", icon: <FaShoppingCart /> },
    { name: "Usuários", path: "/users", icon: <FaUserShield /> },
  ];

  const handleCloseMobile = () => {
    setMobileOpen(false);
    setTimeout(() => setShowHamburger(true), 300);
  };

  const handleOpenMobile = () => {
    setMobileOpen(true);
    setShowHamburger(false);
  };

  const handleLogout = () => {
    if (window.confirm("Deseja sair do sistema?")) {
      logout();
    }
  };

  // ── Conteúdo de navegação compartilhado ──────────────────────────────────
  const NavContent = ({ onLinkClick }) => (
    <>
      <nav
        style={{
          display: "flex",
          flexDirection: "column",
          gap: "var(--space-sm)",
          marginTop: "var(--space-lg)",
          paddingLeft: "var(--space-sm)",
          paddingRight: "var(--space-sm)",
          overflowY: "auto",
          flex: 1,
        }}
      >
        {links.map((link, index) => (
          <NavLink
            key={link.path}
            to={link.path}
            onClick={onLinkClick}
            style={({ isActive }) => ({
              display: "flex",
              alignItems: "center",
              gap: "var(--space-md)",
              padding: "var(--space-md)",
              borderRadius: "var(--radius-lg)",
              textDecoration: "none",
              color: isActive ? "var(--color-primary)" : "var(--color-text)",
              cursor: "pointer",
              transition: "all 300ms ease",
              background: isActive ? "rgba(79, 110, 247, 0.15)" : "transparent",
              border: isActive ? "1px solid rgba(79, 110, 247, 0.3)" : "1px solid transparent",
              fontSize: "var(--text-sm)",
              fontWeight: isActive ? 600 : 500,
              fontFamily: "var(--font-body)",
              transitionDelay: `${index * 50}ms`,
            })}
            onMouseEnter={(e) => {
              e.currentTarget.style.background = "rgba(79, 110, 247, 0.1)";
              e.currentTarget.style.transform = "translateX(4px)";
            }}
            onMouseLeave={(e) => {
              const isActive = e.currentTarget.getAttribute("aria-current") === "page";
              e.currentTarget.style.background = isActive ? "rgba(79, 110, 247, 0.15)" : "transparent";
              e.currentTarget.style.transform = "translateX(0)";
            }}
          >
            <span style={{ fontSize: "18px", display: "flex", alignItems: "center", justifyContent: "center" }}>
              {link.icon}
            </span>
            {!collapsed && <span style={{ whiteSpace: "nowrap" }}>{link.name}</span>}
          </NavLink>
        ))}
      </nav>

      {/* Rodapé: usuário + logout */}
      <div
        style={{
          padding: "var(--space-md)",
          borderTop: "1px solid var(--color-border)",
          marginTop: "auto",
        }}
      >
        {/* Info do usuário */}
        {!collapsed && user && (
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: "var(--space-md)",
              padding: "var(--space-md)",
              marginBottom: "var(--space-sm)",
              borderRadius: "var(--radius-md)",
              background: "rgba(255,255,255,0.03)",
            }}
          >
            <div
              style={{
                width: "32px",
                height: "32px",
                borderRadius: "50%",
                background: "var(--color-primary)",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                fontSize: "13px",
                fontWeight: 700,
                color: "#fff",
                flexShrink: 0,
              }}
            >
              {user.email?.[0]?.toUpperCase() ?? "U"}
            </div>
            <div style={{ minWidth: 0 }}>
              <div
                style={{
                  fontSize: "var(--text-sm)",
                  fontWeight: 600,
                  color: "var(--color-text)",
                  whiteSpace: "nowrap",
                  overflow: "hidden",
                  textOverflow: "ellipsis",
                  maxWidth: "140px",
                }}
              >
                {user.email}
              </div>
              <div style={{ fontSize: "var(--text-xs)", color: "var(--color-textMuted)", textTransform: "capitalize" }}>
                {user.role}
              </div>
            </div>
          </div>
        )}

        {/* Botão logout */}
        <button
          onClick={handleLogout}
          style={{
            display: "flex",
            alignItems: "center",
            gap: "var(--space-md)",
            width: "100%",
            padding: "var(--space-md)",
            borderRadius: "var(--radius-md)",
            background: "transparent",
            border: "1px solid transparent",
            color: "rgba(239, 68, 68, 0.7)",
            cursor: "pointer",
            fontSize: "var(--text-sm)",
            fontWeight: 500,
            fontFamily: "var(--font-body)",
            transition: "all 200ms ease",
            justifyContent: collapsed ? "center" : "flex-start",
          }}
          onMouseEnter={(e) => {
            e.currentTarget.style.background = "rgba(239, 68, 68, 0.08)";
            e.currentTarget.style.borderColor = "rgba(239, 68, 68, 0.2)";
            e.currentTarget.style.color = "#ef4444";
          }}
          onMouseLeave={(e) => {
            e.currentTarget.style.background = "transparent";
            e.currentTarget.style.borderColor = "transparent";
            e.currentTarget.style.color = "rgba(239, 68, 68, 0.7)";
          }}
          title={collapsed ? "Sair" : undefined}
        >
          <span style={{ fontSize: "16px", display: "flex", alignItems: "center" }}>
            <FaSignOutAlt />
          </span>
          {!collapsed && <span>Sair</span>}
        </button>
      </div>
    </>
  );

  return (
    <>
      {/* Botão Hamburger Mobile */}
      {showHamburger && !mobileOpen && (
        <button
          className="fixed top-4 left-4 z-50 md:hidden p-2 rounded focus:outline-none shadow transition-transform duration-300 hover:scale-110"
          style={{
            background: "var(--color-surface2)",
            color: "var(--color-text)",
            border: "1px solid var(--color-border)",
          }}
          onClick={handleOpenMobile}
        >
          <FaBars size={20} />
        </button>
      )}

      {/* Sidebar Desktop */}
      <aside
        style={{
          position: "fixed",
          left: 0,
          top: 0,
          height: "100vh",
          zIndex: 20,
          flexShrink: 0,
          background: "linear-gradient(180deg, var(--color-surface2) 0%, var(--color-surface) 100%)",
          color: "var(--color-text)",
          display: "flex",
          flexDirection: "column",
          width: collapsed ? "80px" : "256px",
          transition: "width 300ms ease",
          borderRight: "1px solid var(--color-border)",
          backdropFilter: "blur(10px)",
        }}
        className="sidebar-desktop"
      >
        {/* Header */}
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            padding: "var(--space-lg)",
            borderBottom: "1px solid var(--color-border)",
            background: "rgba(0, 0, 0, 0.2)",
            flexShrink: 0,
          }}
        >
          {!collapsed && (
            <h2
              style={{
                fontSize: "var(--text-2xl)",
                fontWeight: 700,
                margin: 0,
                fontFamily: "var(--font-display)",
                letterSpacing: "-0.5px",
              }}
            >
              Painel
            </h2>
          )}
          <button
            style={{
              background: "none",
              border: "none",
              color: "var(--color-text)",
              cursor: "pointer",
              padding: "var(--space-sm)",
              fontSize: "18px",
              borderRadius: "var(--radius-md)",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              transition: "color 200ms ease",
            }}
            onClick={() => setCollapsed(!collapsed)}
            onMouseEnter={(e) => (e.currentTarget.style.color = "var(--color-primary)")}
            onMouseLeave={(e) => (e.currentTarget.style.color = "var(--color-text)")}
          >
            <FaBars size={18} style={{ transform: collapsed ? "rotate(180deg)" : "rotate(0deg)", transition: "transform 300ms ease" }} />
          </button>
        </div>

        <NavContent onLinkClick={undefined} />
      </aside>

      {/* Sidebar Mobile */}
      <aside
        style={{
          position: "fixed",
          top: 0,
          left: 0,
          height: "100%",
          background: "linear-gradient(180deg, var(--color-surface2) 0%, var(--color-surface) 100%)",
          color: "var(--color-text)",
          zIndex: 40,
          width: "256px",
          transform: mobileOpen ? "translateX(0)" : "translateX(-100%)",
          transition: "transform 300ms ease-in-out",
          display: "flex",
          flexDirection: "column",
          borderRight: "1px solid var(--color-border)",
        }}
      >
        {/* Header Mobile */}
        <div
          style={{
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            padding: "var(--space-lg)",
            borderBottom: "1px solid var(--color-border)",
            background: "rgba(0, 0, 0, 0.2)",
            flexShrink: 0,
          }}
        >
          <h2
            style={{
              fontSize: "var(--text-2xl)",
              fontWeight: 700,
              margin: 0,
              fontFamily: "var(--font-display)",
              letterSpacing: "-0.5px",
            }}
          >
            Painel
          </h2>
          <button
            style={{
              background: "none",
              border: "none",
              color: "var(--color-text)",
              cursor: "pointer",
              padding: "var(--space-sm)",
              fontSize: "18px",
              borderRadius: "var(--radius-md)",
              display: "flex",
              alignItems: "center",
              transition: "color 200ms ease",
            }}
            onClick={handleCloseMobile}
            onMouseEnter={(e) => (e.currentTarget.style.color = "var(--color-primary)")}
            onMouseLeave={(e) => (e.currentTarget.style.color = "var(--color-text)")}
          >
            <FaBars size={18} />
          </button>
        </div>

        <NavContent onLinkClick={handleCloseMobile} />
      </aside>

      {/* Overlay Mobile */}
      <div
        style={{
          position: "fixed",
          inset: 0,
          background: "rgba(0, 0, 0, 0.4)",
          zIndex: 30,
          opacity: mobileOpen ? 1 : 0,
          pointerEvents: mobileOpen ? "auto" : "none",
          transition: "opacity 300ms ease",
        }}
        className="md:hidden"
        onClick={handleCloseMobile}
      />
    </>
  );
};

export default Sidebar;