import React, { useState } from "react";
import { useAuth } from "../contexts/AuthContext";

const Login = () => {
  const { login } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      await login(email, password);
    } catch (err) {
      setError("Email ou senha inválidos.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen w-full flex items-center justify-center bg-gray-100 px-4 md:px-0">
      <div className="bg-white shadow-xl rounded-lg p-8 w-full max-w-md md:max-w-lg lg:max-w-md animate-fadeIn">
        <h1 className="text-3xl font-bold text-center mb-6 text-gray-800">Bem-vindo 👋</h1>

        {error && <p className="text-center text-red-500 font-medium mb-4">{error}</p>}

        <form onSubmit={handleSubmit} className="space-y-5">
          <div>
            <label className="text-gray-700 font-semibold text-sm">Email</label>
            <input
              type="email"
              className="mt-1 w-full p-3 border rounded-md focus:ring-2 focus:ring-blue-400 transition"
              placeholder="Digite seu email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>

          <div>
            <label className="text-gray-700 font-semibold text-sm">Senha</label>
            <input
              type="password"
              className="mt-1 w-full p-3 border rounded-md focus:ring-2 focus:ring-blue-400 transition"
              placeholder="Digite sua senha"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className={`w-full py-3 rounded-md font-semibold text-white shadow transition-transform ${
              loading ? "bg-blue-400" : "bg-blue-500 hover:bg-blue-600 hover:scale-[1.03]"
            }`}
          >
            {loading ? "Entrando..." : "Entrar"}
          </button>
        </form>
      </div>

      <style>
        {`
          .animate-fadeIn {
            animation: fadeIn 0.35s ease-in-out;
          }
          @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
          }
        `}
      </style>
    </div>
  );
};

export default Login;
