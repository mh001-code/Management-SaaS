import React, { Suspense, lazy } from "react";
import { Routes, Route, Outlet, Navigate } from "react-router-dom";
import Sidebar from "./components/Sidebar";
import PrivateRoute from "./components/PrivateRoute";
import Login from "./pages/Login";
import ToastContainer from "./components/ToastContainer";

import "./theme/theme.css";
import "./styles/globals.css";
import "./index.css";

const Dashboard = lazy(() => import("./pages/Dashboard"));
const Clients   = lazy(() => import("./pages/Clients"));
const Products  = lazy(() => import("./pages/Products"));
const Orders    = lazy(() => import("./pages/Orders"));
const Users     = lazy(() => import("./pages/Users"));
const Financial = lazy(() => import('./pages/Financial'));
const Suppliers = lazy(() => import("./pages/Suppliers"));

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

// Layout protegido: renderiza Sidebar + conteúdo via <Outlet>
const PrivateLayout = () => (
  <PrivateRoute>
    <Sidebar />
    <main className="app-main-layout">
      <Suspense fallback={<PageLoader />}>
        <Outlet />
      </Suspense>
    </main>
  </PrivateRoute>
);

const App = () => (
  <>
    <Routes>
      <Route path="/login" element={<Login />} />

      {/* Todas as rotas protegidas como filhas do layout */}
      <Route element={<PrivateLayout />}>
        <Route index element={<Navigate to="/dashboard" replace />} />
        <Route path="/dashboard"  element={<Dashboard />} />
        <Route path="/clients"    element={<Clients />} />
        <Route path="/products"   element={<Products />} />
        <Route path="/orders"     element={<Orders />} />
        <Route path="/users"      element={<Users />} />
        <Route path="/financial"  element={<Financial />} />
          <Route path="/suppliers"  element={<Suppliers />} />
      </Route>

      {/* Fallback */}
      <Route path="*" element={<Navigate to="/dashboard" replace />} />
    </Routes>

    {/* ToastContainer fora do Routes para funcionar em qualquer rota */}
    <ToastContainer />
  </>
);

export default App;
