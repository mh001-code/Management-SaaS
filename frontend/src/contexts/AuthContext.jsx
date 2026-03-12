import React, { createContext, useContext, useState, useEffect, useCallback, useMemo } from "react";
import api from "../services/api";
import { useNavigate } from "react-router-dom";

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const navigate = useNavigate();
  const [user, setUser] = useState(null);
  const [loadingUser, setLoadingUser] = useState(true);

  // 🔄 Recupera token + valida usuário ao carregar app
  useEffect(() => {
    const token = localStorage.getItem("token");
    const cachedUser = localStorage.getItem("user");

    if (!token) {
      setLoadingUser(false);
      return;
    }

    // Se tem cache de usuário, usar imediatamente
    if (cachedUser) {
      try {
        setUser(JSON.parse(cachedUser));
      } catch (err) {
        console.error("Erro ao parsear usuário em cache:", err);
      }
    }

    api.defaults.headers.common["Authorization"] = `Bearer ${token}`;

    // Validar token
    api
      .get("/auth/me")
      .then((res) => {
        setUser(res.data);
        localStorage.setItem("user", JSON.stringify(res.data));
      })
      .catch(() => {
        localStorage.removeItem("token");
        localStorage.removeItem("user");
        setUser(null);
      })
      .finally(() => setLoadingUser(false));
  }, []);

  /**
   * Login com callback
   */
  const login = useCallback(async (email, password) => {
    const res = await api.post("/auth/login", { email, password });

    const { token, user } = res.data;

    localStorage.setItem("token", token);
    localStorage.setItem("user", JSON.stringify(user));
    api.defaults.headers.common["Authorization"] = `Bearer ${token}`;

    setUser(user);
    navigate("/dashboard");
  }, [navigate]);

  /**
   * Logout
   */
  const logout = useCallback(() => {
    localStorage.removeItem("token");
    localStorage.removeItem("user");
    setUser(null);
    navigate("/login");
  }, [navigate]);

  /**
   * Memoizar valor para evitar re-renders
   */
  const value = useMemo(
    () => ({
      user,
      login,
      logout,
      loadingUser,
      isAuthenticated: !!user,
    }),
    [user, login, logout, loadingUser]
  );

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);

  if (!context) {
    throw new Error("useAuth deve ser usado dentro de AuthProvider");
  }

  return context;
};