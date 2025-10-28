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
import { CSSTransition, TransitionGroup } from "react-transition-group";

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
    <div className="p-4 md:p-6 bg-gray-100 min-h-screen max-w-full md:max-w-6xl mx-auto">
      {/* Cabeçalho */}
      <header className="flex flex-col md:flex-row justify-between items-center mb-6 md:mb-8">
        <h1 className="text-2xl md:text-3xl font-bold mb-4 md:mb-0">
          Dashboard
        </h1>
        <div className="flex items-center gap-3 md:gap-4 flex-wrap">
          <span className="font-medium text-sm md:text-base">
            Olá, {user?.name || "Usuário"}
          </span>
          <button
            onClick={logout}
            className="bg-red-500 text-white px-3 md:px-4 py-2 rounded hover:bg-red-600 transition-transform transform hover:scale-105 text-sm md:text-base"
          >
            Logout
          </button>
        </div>
      </header>

      {/* Filtros de data */}
      <div className="mb-6 md:mb-8 flex flex-col sm:flex-row items-start sm:items-center gap-3 sm:gap-4 flex-wrap">
        <div className="flex flex-col">
          <label className="mb-1 font-semibold text-sm">De:</label>
          <input
            type="date"
            value={dateRange.from}
            onChange={(e) =>
              setDateRange({ ...dateRange, from: e.target.value })
            }
            className="border p-2 rounded text-sm transition-shadow duration-300 focus:shadow-md"
          />
        </div>
        <div className="flex flex-col">
          <label className="mb-1 font-semibold text-sm">Até:</label>
          <input
            type="date"
            value={dateRange.to}
            onChange={(e) =>
              setDateRange({ ...dateRange, to: e.target.value })
            }
            className="border p-2 rounded text-sm transition-shadow duration-300 focus:shadow-md"
          />
        </div>
        <button
          onClick={handleFilter}
          className="bg-blue-500 text-white px-3 md:px-4 py-2 rounded hover:bg-blue-600 transition-transform transform hover:scale-105 mt-2 sm:mt-0 text-sm md:text-base"
        >
          Filtrar
        </button>
      </div>

      {/* Cards de resumo com animação */}
      <TransitionGroup className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4 md:gap-6 mb-6 md:mb-8">
        {[
          {
            label: "Total de Pedidos",
            value:
              summary?.ordersPerClient?.reduce((a, c) => a + Number(c.orders), 0) ||
              0,
            color: "text-blue-500",
          },
          {
            label: "Total de Clientes",
            value: summary?.ordersPerClient?.length || 0,
            color: "text-green-500",
          },
          {
            label: "Receita Total",
            value: `R$ ${summary?.totalSales || "0.00"}`,
            color: "text-yellow-500",
          },
        ].map((card, index) => (
          <CSSTransition key={card.label} timeout={300} classNames="fade-slide">
            <div className="bg-white p-4 md:p-6 rounded shadow hover:shadow-lg transition-transform transform hover:scale-105 text-center">
              <h2 className="font-semibold text-gray-700 mb-1 md:mb-2 text-sm md:text-base">
                {card.label}
              </h2>
              <p className={`text-2xl md:text-3xl font-bold ${card.color}`}>
                {card.value}
              </p>
            </div>
          </CSSTransition>
        ))}
      </TransitionGroup>

      {/* Gráficos com fade-in */}
      <TransitionGroup className="grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-6">
        {/* Produtos em Estoque */}
        <CSSTransition key="topProducts" timeout={400} classNames="fade-slide">
          <div className="bg-white p-4 md:p-6 rounded shadow">
            <h2 className="text-lg md:text-xl font-semibold mb-2 md:mb-4 text-center">
              Produtos em Estoque
            </h2>
            <ResponsiveContainer width="100%" height={250}>
              <BarChart
                data={summary?.topProducts || []}
                margin={{ top: 5, right: 10, left: 0, bottom: 5 }}
              >
                <XAxis dataKey="product" />
                <YAxis />
                <Tooltip />
                <Bar dataKey="sold" fill="#0088FE" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </CSSTransition>

        {/* Pedidos por Status */}
        <CSSTransition key="ordersByStatus" timeout={400} classNames="fade-slide">
          <div className="bg-white p-4 md:p-6 rounded shadow">
            <h2 className="text-lg md:text-xl font-semibold mb-2 md:mb-4 text-center">
              Pedidos por Status
            </h2>
            {summary?.ordersByStatus?.length > 0 ? (
              <ResponsiveContainer width="100%" height={250}>
                <PieChart>
                  <Pie
                    data={summary.ordersByStatus}
                    dataKey="count"
                    nameKey="status"
                    cx="50%"
                    cy="50%"
                    outerRadius={60}
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
        </CSSTransition>

        {/* Pedidos por Cliente */}
        <CSSTransition key="ordersPerClient" timeout={400} classNames="fade-slide">
          <div className="bg-white p-4 md:p-6 rounded shadow md:col-span-2">
            <h2 className="text-lg md:text-xl font-semibold mb-2 md:mb-4 text-center">
              Pedidos por Cliente
            </h2>
            <ResponsiveContainer width="100%" height={250}>
              <BarChart data={summary?.ordersPerClient || []}>
                <XAxis dataKey="client" />
                <YAxis />
                <Tooltip />
                <Bar dataKey="orders" fill="#FF8042" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </CSSTransition>
      </TransitionGroup>
    </div>
  );
};

export default Dashboard;