import React from "react";
import { NavLink } from "react-router-dom";

const Sidebar = () => {
  const links = [
    { name: "Dashboard", path: "/" },
    { name: "Clientes", path: "/clients" },
    { name: "Produtos", path: "/products" },
    { name: "Pedidos", path: "/orders" },
    { name: "Usuários", path: "/users" },
  ];

  return (
    <aside className="w-64 bg-gray-800 text-white min-h-screen p-6">
      <h2 className="text-2xl font-bold mb-6">Painel</h2>
      <nav className="flex flex-col gap-4">
        {links.map((link) => (
          <NavLink
            key={link.path}
            to={link.path}
            className={({ isActive }) =>
              `p-2 rounded hover:bg-gray-700 ${isActive ? "bg-gray-700" : ""}`
            }
          >
            {link.name}
          </NavLink>
        ))}
      </nav>
    </aside>
  );
};

export default Sidebar;
