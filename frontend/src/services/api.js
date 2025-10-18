import axios from "axios";

const api = axios.create({
  baseURL: "http://localhost:5000/api", // ajuste para o seu backend
});

// Interceptor para enviar token automaticamente
api.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default api;
