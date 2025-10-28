import React, { useState } from "react";
import { NavLink } from "react-router-dom";
import { FaBars, FaTachometerAlt, FaUsers, FaBoxOpen, FaShoppingCart, FaUserShield } from "react-icons/fa";

const Sidebar = () => {
  const [collapsed, setCollapsed] = useState(false);

  const links = [
    { name: "Dashboard", path: "/", icon: <FaTachometerAlt /> },
    { name: "Clientes", path: "/clients", icon: <FaUsers /> },
    { name: "Produtos", path: "/products", icon: <FaBoxOpen /> },
    { name: "Pedidos", path: "/orders", icon: <FaShoppingCart /> },
    { name: "Usuários", path: "/users", icon: <FaUserShield /> },
  ];

  return (
    <div className="flex">
      {/* Sidebar */}
      <aside
        className={`bg-gray-800 text-white min-h-screen p-4 transition-all duration-300 ${
          collapsed ? "w-20" : "w-64"
        }`}
      >
        <div className="flex justify-between items-center mb-6">
          {!collapsed && <h2 className="text-2xl font-bold">Painel</h2>}
          <button
            onClick={() => setCollapsed(!collapsed)}
            className="text-white focus:outline-none"
          >
            <FaBars size={20} />
          </button>
        </div>

        <nav className="flex flex-col gap-4">
          {links.map((link) => (
            <NavLink
              key={link.path}
              to={link.path}
              className={({ isActive }) =>
                `flex items-center gap-3 p-2 rounded hover:bg-gray-700 ${
                  isActive ? "bg-gray-700" : ""
                }`
              }
            >
              <span className="text-lg">{link.icon}</span>
              {!collapsed && <span>{link.name}</span>}
            </NavLink>
          ))}
        </nav>
      </aside>

      {/* Conteúdo principal */}
      <main className="flex-1 p-6 bg-gray-100 min-h-screen">
        {/* Aqui entra o conteúdo das páginas */}
      </main>
    </div>
  );
};

export default Sidebar;