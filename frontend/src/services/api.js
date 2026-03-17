import axios from "axios";
import errorService from "./errorService";
import notificationService from "./notificationService";

const api = axios.create({
  // ✅ Vite usa import.meta.env, não process.env
  baseURL: import.meta.env.VITE_API_URL || "http://localhost:5000/api",
  timeout: 10000,
});

// Interceptador de requisição — adiciona token JWT
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

// Interceptador de resposta — tratamento centralizado de erros
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (errorService.isAuthError(error)) {
      localStorage.removeItem("token");
      localStorage.removeItem("user");
      window.location.href = "/login";
    }
    return Promise.reject(error);
  }
);

export default api;