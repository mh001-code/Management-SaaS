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
  const [dateRange, setDateRange] = useState({ from: "", to: "" });

  const fetchSummary = async () => {
    try {
      const res = await api.get("/summary", {
        headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
        params: dateRange.from && dateRange.to ? { from: dateRange.from, to: dateRange.to } : {},
      });
      console.log("Resumo recebido do backend:", res.data);
      setSummary(res.data);
    } catch (err) {
      console.error("Erro ao buscar resumo:", err);
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

  return (
    <div className="p-6 bg-gray-100 min-h-screen">
      {/* Cabeçalho */}
      <header className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Dashboard</h1>
        <div>
          <span className="mr-4">Olá, {user?.name}</span>
          <button
            onClick={logout}
            className="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"
          >
            Logout
          </button>
        </div>
      </header>

      {/* Filtros de data */}
      <div className="mb-6 flex flex-col md:flex-row items-start md:items-center gap-4">
        <div>
          <label className="block mb-1 font-semibold">De:</label>
          <input
            type="date"
            value={dateRange.from}
            onChange={(e) => setDateRange({ ...dateRange, from: e.target.value })}
            className="border p-2 rounded"
          />
        </div>
        <div>
          <label className="block mb-1 font-semibold">Até:</label>
          <input
            type="date"
            value={dateRange.to}
            onChange={(e) => setDateRange({ ...dateRange, to: e.target.value })}
            className="border p-2 rounded"
          />
        </div>
        <button
          onClick={handleFilter}
          className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 mt-4 md:mt-0"
        >
          Filtrar
        </button>
      </div>

      {/* Resumo geral */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
        <div className="bg-white p-4 rounded shadow text-center">
          <h2 className="font-semibold mb-2">Total de Pedidos</h2>
          <p className="text-xl">
            {summary.ordersPerClient?.reduce((a, c) => a + Number(c.orders), 0) || 0}
          </p>
        </div>
        <div className="bg-white p-4 rounded shadow text-center">
          <h2 className="font-semibold mb-2">Total de Clientes</h2>
          <p className="text-xl">{summary.ordersPerClient?.length || 0}</p>
        </div>
        <div className="bg-white p-4 rounded shadow text-center">
          <h2 className="font-semibold mb-2">Receita Total</h2>
          <p className="text-xl">R$ {summary.totalSales || "0.00"}</p>
        </div>
      </div>

      {/* Gráficos */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Produtos em Estoque / Top Products */}
        <div className="bg-white p-4 rounded shadow">
          <h2 className="text-lg font-semibold mb-4">Produtos em Estoque</h2>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart
              data={summary.topProducts}
              margin={{ top: 5, right: 30, left: 0, bottom: 5 }}
            >
              <XAxis dataKey="product" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="sold" fill="#0088FE" />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Pedidos por Status */}
        <div className="bg-white p-4 rounded shadow">
          <h2 className="text-lg font-semibold mb-4">Pedidos por Status</h2>
          {summary.ordersByStatus && summary.ordersByStatus.length > 0 ? (
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={summary.ordersByStatus}
                  dataKey="count"
                  nameKey="status"
                  cx="50%"
                  cy="50%"
                  outerRadius={80}
                  fill="#00C49F"
                  label
                >
                  {summary.ordersByStatus.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Legend />
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          ) : (
            <p className="text-center text-gray-500">Nenhum dado disponível</p>
          )}
        </div>

        {/* Pedidos por Cliente */}
        <div className="bg-white p-4 rounded shadow md:col-span-2">
          <h2 className="text-lg font-semibold mb-4">Pedidos por Cliente</h2>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={summary.ordersPerClient}>
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
