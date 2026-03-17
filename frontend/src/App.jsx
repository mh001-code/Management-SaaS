import React, { Suspense, lazy } from "react";
import { Routes, Route, Outlet } from "react-router-dom";
import Sidebar from "./components/Sidebar";
import PrivateRoute from "./components/PrivateRoute";
import Login from "./pages/Login";

import "./theme/theme.css";
import "./styles/globals.css";
import "./index.css";

// Lazy load das páginas para code-splitting
const Dashboard = lazy(() => import("./pages/Dashboard"));
const Clients = lazy(() => import("./pages/Clients"));
const Products = lazy(() => import("./pages/Products"));
const Orders = lazy(() => import("./pages/Orders"));
const Users = lazy(() => import("./pages/Users"));

const PageLoader = () => (
  <div style={{
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    minHeight: "100vh",
    backgroundColor: "#0a0a0f",
  }}>
    <div style={{
      width: "40px",
      height: "40px",
      border: "3px solid rgba(255,255,255,0.1)",
      borderTopColor: "#4f6ef7",
      borderRadius: "50%",
      animation: "spin 1s linear infinite",
    }} />
  </div>
);

// ✅ Suspense único aqui — removidos os Suspense individuais por rota
const PrivateLayout = () => (
  <main className="app-main-layout">
    <Suspense fallback={<PageLoader />}>
      <Outlet />
    </Suspense>
  </main>
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
            <>
              <Sidebar />
              <PrivateLayout />
            </>
          </PrivateRoute>
        }
      >
        <Route index element={<Dashboard />} />
        <Route path="dashboard" element={<Dashboard />} />
        <Route path="clients" element={<Clients />} />
        <Route path="products" element={<Products />} />
        <Route path="orders" element={<Orders />} />
        <Route path="users" element={<Users />} />
      </Route>
    </Routes>
  );
};

export default App;