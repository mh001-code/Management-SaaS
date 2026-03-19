import React, { Suspense, lazy } from "react";
import { Routes, Route, Outlet, Navigate } from "react-router-dom";
import Sidebar from "./components/Sidebar";
import PrivateRoute from "./components/PrivateRoute";
import Login from "./pages/Login";
import ToastContainer from "./components/ToastContainer";
import { ThemeProvider } from "./contexts/ThemeContext";

import "./theme/theme.css";
import "./index.css";
/* globals.css REMOVIDO — continha backgrounds hardcoded que quebravam o tema */

const Dashboard    = lazy(() => import("./pages/Dashboard"));
const Clients      = lazy(() => import("./pages/Clients"));
const Products     = lazy(() => import("./pages/Products"));
const Orders       = lazy(() => import("./pages/Orders"));
const Users        = lazy(() => import("./pages/Users"));
const Reports      = lazy(() => import("./pages/Reports"));
const Financial    = lazy(() => import("./pages/Financial"));
const Suppliers    = lazy(() => import("./pages/Suppliers"));
const PurchaseOrders = lazy(() => import("./pages/PurchaseOrders"));

const PageLoader = () => (
  <div style={{
    display: "flex", alignItems: "center", justifyContent: "center",
    minHeight: "100vh", backgroundColor: "var(--color-bg)",
  }}>
    <div style={{
      width: 40, height: 40,
      border: "3px solid var(--color-border2)",
      borderTopColor: "var(--color-primary)",
      borderRadius: "50%",
      animation: "spin 1s linear infinite",
    }} />
  </div>
);

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
  <ThemeProvider>
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route element={<PrivateLayout />}>
        <Route index element={<Navigate to="/dashboard" replace />} />
        <Route path="/dashboard"       element={<Dashboard />} />
        <Route path="/clients"         element={<Clients />} />
        <Route path="/products"        element={<Products />} />
        <Route path="/orders"          element={<Orders />} />
        <Route path="/users"           element={<Users />} />
        <Route path="/reports"         element={<Reports />} />
        <Route path="/financial"       element={<Financial />} />
        <Route path="/suppliers"       element={<Suppliers />} />
        <Route path="/purchase-orders" element={<PurchaseOrders />} />
      </Route>
      <Route path="*" element={<Navigate to="/dashboard" replace />} />
    </Routes>
    <ToastContainer />
  </ThemeProvider>
);

export default App;