import axios from "axios";

const api = axios.create({
  baseURL: "http://localhost:5000/api",
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");

  console.log("%c[API LOG] Interceptando requisição:", "color: cyan");
  console.log("→ URL:", config.url);
  console.log("→ Método:", config.method);
  console.log("→ Token encontrado:", token ? "✅ SIM" : "❌ NÃO");

  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
    console.log("→ Header Authorization adicionado:", config.headers.Authorization);
  } else {
    console.warn("⚠️ Nenhum token no localStorage!");
  }

  return config;
});

export default api;