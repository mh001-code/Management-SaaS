import React from "react";
import { Routes, Route, Outlet } from "react-router-dom";
import Sidebar from "./components/Sidebar";
import PrivateRoute from "./components/PrivateRoute";

import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import Clients from "./pages/Clients";
import Products from "./pages/Products";
import Orders from "./pages/Orders";
import Users from "./pages/Users";

const PrivateLayout = () => (
  <div className="flex w-full">
    <Sidebar />
    <main className="flex-1 bg-gray-100 min-h-screen p-6">
      <Outlet /> {/* ← Aqui é onde as páginas aparecem */}
    </main>
  </div>
);

const App = () => {
  return (
    <Routes>
      {/* Rota pública */}
      <Route path="/login" element={<Login />} />

      {/* Rotas protegidas */}
      <Route
        path="/"
        element={
          <PrivateRoute>
            <PrivateLayout />
          </PrivateRoute>
        }
      >
        <Route index element={<Dashboard />} />    {/* / */}
        <Route path="dashboard" element={<Dashboard />} /> {/* /dashboard */}
        <Route path="clients" element={<Clients />} />
        <Route path="products" element={<Products />} />
        <Route path="orders" element={<Orders />} />
        <Route path="users" element={<Users />} />
      </Route>
    </Routes>
  );
};

export default App;