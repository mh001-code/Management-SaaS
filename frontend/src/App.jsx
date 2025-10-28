import React from "react";
import { Routes, Route } from "react-router-dom";
import Sidebar from "./components/Sidebar";
import PrivateRoute from "./components/PrivateRoute";

import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import Clients from "./pages/Clients";
import Products from "./pages/Products";
import Orders from "./pages/Orders";
import Users from "./pages/Users";

const App = () => {
  return (
    <div className="flex">
      {/* Sidebar só aparece em rotas privadas */}
      <Routes>
        <Route
          path="/*"
          element={
            <PrivateRoute>
              <div className="flex w-full">
                <Sidebar />
                <main className="flex-1 bg-gray-100 min-h-screen p-6">
                  <Routes>
                    <Route path="/" element={<Dashboard />} />
                    <Route path="/clients" element={<Clients />} />
                    <Route path="/products" element={<Products />} />
                    <Route path="/orders" element={<Orders />} />
                    <Route path="/users" element={<Users />} />
                  </Routes>
                </main>
              </div>
            </PrivateRoute>
          }
        />

        {/* Rota pública de login */}
        <Route path="/login" element={<Login />} />
      </Routes>
    </div>
  );
};

export default App;
