import React, { useEffect, useState } from "react";
import { useAuth } from "../contexts/AuthContext";
import api from "../services/api";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  Legend,
} from "recharts";

const COLORS = ["#0088FE", "#00C49F", "#FFBB28", "#FF8042"];

const Dashboard = () => {
  const { user, logout } = useAuth();
  const [summary, setSummary] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [dateRange, setDateRange] = useState({ from: "", to: "" });

  const fetchSummary = async () => {
    try {
      setError("");
      const res = await api.get("/summary", {
        headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
        params:
          dateRange.from && dateRange.to
            ? { from: dateRange.from, to: dateRange.to }
            : {},
      });
      setSummary(res.data);
    } catch (err) {
      console.error("Erro ao buscar resumo:", err);
      if (err.response && err.response.status === 401) {
        setError("Sessão expirada. Faça login novamente.");
        logout();
      } else {
        setError("Falha ao carregar os dados.");
      }
      setSummary(null);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchSummary();
  }, []);

  const handleFilter = () => {
    setLoading(true);
    fetchSummary();
  };

  if (loading) return <div className="p-6 text-center">Carregando...</div>;
  if (error)
    return (
      <div className="p-6 text-center text-red-500 font-semibold">{error}</div>
    );

  return (
    <div className="p-6 bg-gray-100 min-h-screen max-w-6xl mx-auto">
      {/* Cabeçalho */}
      <header className="flex flex-col md:flex-row justify-between items-center mb-8">
        <h1 className="text-3xl font-bold mb-4 md:mb-0">Dashboard</h1>
        <div className="flex items-center gap-4">
          <span className="font-medium">Olá, {user?.name || "Usuário"}</span>
          <button
            onClick={logout}
            className="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 transition"
          >
            Logout
          </button>
        </div>
      </header>

      {/* Filtros de data */}
      <div className="mb-8 flex flex-col md:flex-row items-start md:items-center gap-4">
        <div>
          <label className="block mb-1 font-semibold">De:</label>
          <input
            type="date"
            value={dateRange.from}
            onChange={(e) =>
              setDateRange({ ...dateRange, from: e.target.value })
            }
            className="border p-2 rounded"
          />
        </div>
        <div>
          <label className="block mb-1 font-semibold">Até:</label>
          <input
            type="date"
            value={dateRange.to}
            onChange={(e) =>
              setDateRange({ ...dateRange, to: e.target.value })
            }
            className="border p-2 rounded"
          />
        </div>
        <button
          onClick={handleFilter}
          className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-2 md:mt-0 transition"
        >
          Filtrar
        </button>
      </div>

      {/* Cards de resumo */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div className="bg-white p-6 rounded shadow hover:shadow-lg transition text-center">
          <h2 className="font-semibold text-gray-700 mb-2">Total de Pedidos</h2>
          <p className="text-3xl font-bold text-blue-500">
            {summary?.ordersPerClient?.reduce((a, c) => a + Number(c.orders), 0) || 0}
          </p>
        </div>
        <div className="bg-white p-6 rounded shadow hover:shadow-lg transition text-center">
          <h2 className="font-semibold text-gray-700 mb-2">Total de Clientes</h2>
          <p className="text-3xl font-bold text-green-500">
            {summary?.ordersPerClient?.length || 0}
          </p>
        </div>
        <div className="bg-white p-6 rounded shadow hover:shadow-lg transition text-center">
          <h2 className="font-semibold text-gray-700 mb-2">Receita Total</h2>
          <p className="text-3xl font-bold text-yellow-500">
            R$ {summary?.totalSales || "0.00"}
          </p>
        </div>
      </div>

      {/* Gráficos */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Produtos em Estoque */}
        <div className="bg-white p-6 rounded shadow">
          <h2 className="text-xl font-semibold mb-4 text-center">Produtos em Estoque</h2>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart
              data={summary?.topProducts || []}
              margin={{ top: 5, right: 20, left: 0, bottom: 5 }}
            >
              <XAxis dataKey="product" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="sold" fill="#0088FE" />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Pedidos por Status */}
        <div className="bg-white p-6 rounded shadow">
          <h2 className="text-xl font-semibold mb-4 text-center">Pedidos por Status</h2>
          {summary?.ordersByStatus?.length > 0 ? (
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={summary.ordersByStatus}
                  dataKey="count"
                  nameKey="status"
                  cx="50%"
                  cy="50%"
                  outerRadius={80}
                  label
                >
                  {summary.ordersByStatus.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Legend verticalAlign="bottom" />
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          ) : (
            <p className="text-center text-gray-500">Nenhum dado disponível</p>
          )}
        </div>

        {/* Pedidos por Cliente */}
        <div className="bg-white p-6 rounded shadow md:col-span-2">
          <h2 className="text-xl font-semibold mb-4 text-center">Pedidos por Cliente</h2>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={summary?.ordersPerClient || []}>
              <XAxis dataKey="client" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="orders" fill="#FF8042" />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;