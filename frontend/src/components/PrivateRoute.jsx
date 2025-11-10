import React from "react";
import { Navigate } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext";

const PrivateRoute = ({ children }) => {
  const { user, loadingUser } = useAuth();

  // Enquanto ainda estamos verificando se existe sessão → mostra loader
  if (loadingUser) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-100">
        <div className="text-gray-600 text-lg font-medium">
          Carregando...
        </div>
      </div>
    );
  }

  // Se não tiver usuário → redireciona
  if (!user) {
    return <Navigate to="/login" replace />;
  }

  // Se estiver tudo ok → renderiza a página protegida
  return children;
};

export default PrivateRoute;