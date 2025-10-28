import React, { useState } from "react";
import { NavLink } from "react-router-dom";
import { FaBars, FaTachometerAlt, FaUsers, FaBoxOpen, FaShoppingCart, FaUserShield } from "react-icons/fa";

const Sidebar = ({ children }) => {
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
    setTimeout(() => setShowHamburger(true), 300); // 300ms = mesma duração da animação da sidebar
  };

  const handleOpenMobile = () => {
    setMobileOpen(true);
    setShowHamburger(false);
  };

  return (
    <div className="flex">
      {/* Botão Hamburger Mobile */}
      {showHamburger && !mobileOpen && (
        <button
          className="fixed top-4 left-4 z-50 md:hidden bg-gray-800 text-white p-2 rounded focus:outline-none shadow transition-transform duration-300 hover:scale-110"
          onClick={handleOpenMobile}
        >
          <FaBars size={20} />
        </button>
      )}

      {/* Sidebar Desktop */}
      <aside
        className={`hidden md:flex flex-col bg-gray-800 text-white min-h-screen transition-all duration-300 ${
          collapsed ? "w-20" : "w-64"
        }`}
      >
        <div className="flex justify-between items-center p-4 border-b border-gray-700">
          {!collapsed && <h2 className="text-2xl font-bold transition-opacity duration-300">Painel</h2>}
          <button
            className={`text-white focus:outline-none transform transition-transform duration-300 ${
              collapsed ? "rotate-180" : "rotate-0"
            }`}
            onClick={() => setCollapsed(!collapsed)}
          >
            <FaBars size={20} />
          </button>
        </div>
        <nav className="flex flex-col gap-2 mt-4 px-2">
          {links.map((link, index) => (
            <NavLink
              key={link.path}
              to={link.path}
              className={({ isActive }) =>
                `flex items-center gap-3 p-2 rounded hover:bg-gray-700 transition-all duration-300 transform hover:scale-105 ${
                  isActive ? "bg-gray-700" : ""
                }`
              }
              style={{ transitionDelay: `${index * 50}ms` }} // animação escalonada
            >
              <span className="text-lg">{link.icon}</span>
              {!collapsed && <span>{link.name}</span>}
            </NavLink>
          ))}
        </nav>
      </aside>

      {/* Sidebar Mobile */}
      <aside
        className={`fixed top-0 left-0 h-full bg-gray-800 text-white z-40 w-64 transform transition-transform duration-300 ease-in-out md:hidden
          ${mobileOpen ? "translate-x-0" : "-translate-x-full"}`}
      >
        <div className="flex items-center justify-between p-4 border-b border-gray-700">
          <h2 className="text-2xl font-bold transition-opacity duration-300">Painel</h2>
          <button
            className="text-white focus:outline-none transition-transform duration-300 hover:rotate-90"
            onClick={handleCloseMobile}
          >
            <FaBars size={20} />
          </button>
        </div>

        <nav className="flex flex-col gap-2 mt-4 px-2">
          {links.map((link, index) => (
            <NavLink
              key={link.path}
              to={link.path}
              className={({ isActive }) =>
                `flex items-center gap-3 p-2 rounded hover:bg-gray-700 transition-all duration-300 transform hover:scale-105 ${
                  isActive ? "bg-gray-700" : ""
                }`
              }
              style={{ transitionDelay: `${index * 50}ms` }}
              onClick={handleCloseMobile}
            >
              <span className="text-lg">{link.icon}</span>
              <span>{link.name}</span>
            </NavLink>
          ))}
        </nav>
      </aside>

      {/* Overlay Mobile */}
      <div
        className={`fixed inset-0 bg-black z-30 md:hidden transition-opacity duration-300 ${
          mobileOpen ? "opacity-30 pointer-events-auto" : "opacity-0 pointer-events-none"
        }`}
        onClick={handleCloseMobile}
      />

      {/* Conteúdo Principal com movimento */}
      <main
        className={`flex-1 transition-transform duration-300 ease-in-out ${
          mobileOpen ? "translate-x-64" : "translate-x-0"
        }`}
      >
        {children}
      </main>
    </div>
  );
};

export default Sidebar;