import React, { Suspense, lazy } from "react";
import { Routes, Route, Outlet } from "react-router-dom";
import Sidebar from "./components/Sidebar";
import PrivateRoute from "./components/PrivateRoute";
import Login from "./pages/Login";

// Lazy load das páginas para code-splitting
const Dashboard = lazy(() => import("./pages/Dashboard"));
const Clients = lazy(() => import("./pages/Clients"));
const Products = lazy(() => import("./pages/Products"));
const Orders = lazy(() => import("./pages/Orders"));
const Users = lazy(() => import("./pages/Users"));

/**
 * Componente de loading para suspense
 */
const PageLoader = () => (
  <div style={{
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: '100vh',
    backgroundColor: '#0a0a0f',
  }}>
    <div style={{
      width: '40px',
      height: '40px',
      border: '3px solid rgba(255,255,255,0.1)',
      borderTopColor: '#4f6ef7',
      borderRadius: '50%',
      animation: 'spin 1s linear infinite',
    }} />
  </div>
);

const PrivateLayout = () => (
  <main style={{ flex: 1, minHeight: '100vh' }}>
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
            <div style={{ display: 'flex', width: '100%', height: '100vh' }}>
              <Sidebar />
              <PrivateLayout />
            </div>
          </PrivateRoute>
        }
      >
        <Route
          index
          element={
            <Suspense fallback={<PageLoader />}>
              <Dashboard />
            </Suspense>
          }
        />
        <Route
          path="dashboard"
          element={
            <Suspense fallback={<PageLoader />}>
              <Dashboard />
            </Suspense>
          }
        />
        <Route
          path="clients"
          element={
            <Suspense fallback={<PageLoader />}>
              <Clients />
            </Suspense>
          }
        />
        <Route
          path="products"
          element={
            <Suspense fallback={<PageLoader />}>
              <Products />
            </Suspense>
          }
        />
        <Route
          path="orders"
          element={
            <Suspense fallback={<PageLoader />}>
              <Orders />
            </Suspense>
          }
        />
        <Route
          path="users"
          element={
            <Suspense fallback={<PageLoader />}>
              <Users />
            </Suspense>
          }
        />
      </Route>
    </Routes>
  );
};

export default App;