import axios from "axios";
import errorService from "./errorService";
import notificationService from "./notificationService";

const api = axios.create({
  baseURL: process.env.REACT_APP_API_URL || "http://localhost:5000/api",
  timeout: 10000,
});

/**
 * Interceptador de requisição - Adiciona token JWT
 */
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("token");

    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    return config;
  },
  (error) => Promise.reject(error)
);

/**
 * Interceptador de resposta - Tratamento centralizado de erros
 */
api.interceptors.response.use(
  (response) => response,
  (error) => {
    // Se for erro de autenticação, fazer logout
    if (errorService.isAuthError(error)) {
      localStorage.removeItem("token");
      localStorage.removeItem("user");
      window.location.href = "/login";
    }

    return Promise.reject(error);
  }
);

export default api;
