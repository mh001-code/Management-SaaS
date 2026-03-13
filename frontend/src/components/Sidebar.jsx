import React, { useState } from "react";
import { NavLink } from "react-router-dom";
import { FaBars, FaTachometerAlt, FaUsers, FaBoxOpen, FaShoppingCart, FaUserShield } from "react-icons/fa";

const Sidebar = () => {
  const [collapsed, setCollapsed] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const [showHamburger, setShowHamburger] = useState(true);

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
          overflowY: "auto",
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
                transition: "opacity 300ms ease",
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
              transition: "transform 300ms ease, color 300ms ease",
              borderRadius: "var(--radius-md)",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
            }}
            onClick={() => setCollapsed(!collapsed)}
            onMouseEnter={(e) => (e.target.style.color = "var(--color-primary)")}
            onMouseLeave={(e) => (e.target.style.color = "var(--color-text)")}
          >
            <FaBars size={18} style={{ transform: collapsed ? "rotate(180deg)" : "rotate(0deg)", transition: "transform 300ms ease" }} />
          </button>
        </div>

        {/* Navigation */}
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
                opacity: collapsed ? (isActive ? 1 : 0.7) : 1,
              })}
              onMouseEnter={(e) => {
                if (!e.currentTarget.classList.contains("active")) {
                  e.currentTarget.style.background = "rgba(79, 110, 247, 0.1)";
                  e.currentTarget.style.transform = "translateX(4px)";
                }
              }}
              onMouseLeave={(e) => {
                if (!e.currentTarget.classList.contains("active")) {
                  e.currentTarget.style.background = "transparent";
                  e.currentTarget.style.transform = "translateX(0)";
                }
              }}
            >
              <span style={{ fontSize: "18px", display: "flex", alignItems: "center", justifyContent: "center" }}>
                {link.icon}
              </span>
              {!collapsed && <span style={{ whiteSpace: "nowrap" }}>{link.name}</span>}
            </NavLink>
          ))}
        </nav>
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
          backdropFilter: "blur(10px)",
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
              transition: "color 300ms ease, transform 300ms ease",
              borderRadius: "var(--radius-md)",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
            }}
            onClick={handleCloseMobile}
            onMouseEnter={(e) => (e.target.style.color = "var(--color-primary)")}
            onMouseLeave={(e) => (e.target.style.color = "var(--color-text)")}
          >
            <FaBars size={18} />
          </button>
        </div>

        {/* Navigation Mobile */}
        <nav
          style={{
            display: "flex",
            flexDirection: "column",
            gap: "var(--space-sm)",
            marginTop: "var(--space-lg)",
            paddingLeft: "var(--space-sm)",
            paddingRight: "var(--space-sm)",
            flex: 1,
            overflowY: "auto",
          }}
        >
          {links.map((link, index) => (
            <NavLink
              key={link.path}
              to={link.path}
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
              onClick={handleCloseMobile}
              onMouseEnter={(e) => {
                if (!e.currentTarget.classList.contains("active")) {
                  e.currentTarget.style.background = "rgba(79, 110, 247, 0.1)";
                  e.currentTarget.style.transform = "translateX(4px)";
                }
              }}
              onMouseLeave={(e) => {
                if (!e.currentTarget.classList.contains("active")) {
                  e.currentTarget.style.background = "transparent";
                  e.currentTarget.style.transform = "translateX(0)";
                }
              }}
            >
              <span style={{ fontSize: "18px", display: "flex", alignItems: "center", justifyContent: "center" }}>
                {link.icon}
              </span>
              <span>{link.name}</span>
            </NavLink>
          ))}
        </nav>
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