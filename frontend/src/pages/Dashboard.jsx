import React, { useEffect, useState } from "react";
import { useAuth } from "../contexts/AuthContext";
import api from "../services/api";
import { formatCurrency } from "../utils/formatCurrency";
import {
  BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer,
  PieChart, Pie, Cell, Legend,
} from "recharts";

/* Mapa de cores para status - mesmo do Orders.jsx */
const STATUS_COLORS = {
  pendente: "#f59e0b",
  pago: "#22c55e",
  enviado: "#3b82f6",
  entregue: "#4f6ef7",
  concluído: "#22c55e",
  cancelado: "#ef4444",
  estornado: "#f97316",
  recusado: "#dc2626",
  completed: "#22c55e", // Em caso de status em inglês
};

/* Custom Tooltip */
const CustomTooltip = ({ active, payload, label }) => {
  if (active && payload && payload.length) {
    return (
      <div style={{
        background: "#17171f", border: "1px solid rgba(255,255,255,0.1)",
        borderRadius: 8, padding: "10px 14px", fontFamily: "'DM Sans',sans-serif",
        fontSize: 12, color: "#e8e8f0", boxShadow: "0 4px 12px rgba(0,0,0,0.3)"
      }}>
        <div style={{ color: "rgba(255,255,255,0.5)", marginBottom: 4, fontSize: 11 }}>{label}</div>
        {payload.map((p, i) => (
          <div key={i} style={{ color: p.color || "#4f6ef7", fontWeight: 600, fontSize: 13 }}>
            {p.name}: {p.value}
          </div>
        ))}
      </div>
    );
  }
  return null;
};

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
        params: dateRange.from && dateRange.to ? { from: dateRange.from, to: dateRange.to } : {},
      });
      setSummary(res.data);
    } catch (err) {
      if (err.response?.status === 401) {
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

  useEffect(() => { fetchSummary(); }, []);

  const totalOrders = summary?.ordersPerClient?.reduce((a, c) => a + Number(c.orders), 0) || 0;
  const totalClients = summary?.ordersPerClient?.length || 0;
  const totalRevenue = summary?.totalSales || "0.00";

  const STAT_CARDS = [
    { id: 1, icon: "📦", label: "Total de Pedidos", value: totalOrders, accent: "#4f6ef7", delay: "fade-up-1" },
    { id: 2, icon: "👥", label: "Clientes Ativos", value: totalClients, accent: "#06b6d4", delay: "fade-up-2" },
    { id: 3, icon: "💰", label: "Receita Total", value: formatCurrency(totalRevenue), accent: "#a78bfa", delay: "fade-up-3" },
  ];

  return (
    <div className="main-content">
      {/* Topbar */}
      <div className="topbar">
        <div>
          <div className="topbar-title">📊 Dashboard</div>
          <p style={{ color: "rgba(255,255,255,0.5)", fontSize: "var(--text-sm)", margin: 0, marginTop: "var(--space-xs)" }}>
            Visão completa do seu negócio
          </p>
        </div>
        <div className="topbar-right">
          <div className="date-filter">
            <span className="date-label">De</span>
            <input type="date" className="date-input" value={dateRange.from}
              onChange={(e) => setDateRange({ ...dateRange, from: e.target.value })} />
            <span className="date-label">Até</span>
            <input type="date" className="date-input" value={dateRange.to}
              onChange={(e) => setDateRange({ ...dateRange, to: e.target.value })} />
            <button className="btn btn-primary btn-sm" onClick={() => { setLoading(true); fetchSummary(); }}>
              Aplicar
            </button>
          </div>
        </div>
      </div>

      {/* Body */}
      <div className="page-body">
        {loading ? (
          <div className="loading-center">
            <div className="spinner-ring" />
            <span>Carregando dashboard...</span>
          </div>
        ) : error ? (
          <div className="empty-state">
            <div className="empty-state-icon">⚠️</div>
            <div className="empty-state-text" style={{ color: "#f87171" }}>{error}</div>
          </div>
        ) : (
          <>
            {/* KPI Section */}
            <section className="dashboard-section">
              <div className="section-header">
                <h2 className="section-title">Indicadores Principais</h2>
                <p className="section-subtitle">KPIs principais do período</p>
              </div>
              <div className="stat-grid">
                {STAT_CARDS.map((card) => (
                  <div key={card.id} className={`stat-card animate-fadeUp ${card.delay}`}>
                    <div className="stat-accent-line" style={{ background: card.accent }} />
                    <div className="stat-header">
                      <span className="stat-card-icon">{card.icon}</span>
                      <div className="stat-badge" style={{ background: card.accent }} />
                    </div>
                    <div className="stat-card-label">{card.label}</div>
                    <div className="stat-card-value">{card.value}</div>
                  </div>
                ))}
              </div>
            </section>

            {/* Charts Section */}
            <section className="dashboard-section">
              <div className="section-header">
                <h2 className="section-title">Análise de Desempenho</h2>
                <p className="section-subtitle">Visualize dados e tendências</p>
              </div>

              {/* Two-column charts */}
              <div className="charts-grid">
                {/* Produtos Mais Vendidos */}
                <div className="chart-card animate-fadeUp fade-up-1">
                  <div className="chart-header">
                    <div className="chart-title">📦 Produtos Mais Vendidos</div>
                    <span className="chart-meta">{summary?.topProducts?.length || 0} produtos</span>
                  </div>
                  {summary?.topProducts?.length > 0 ? (
                    <ResponsiveContainer width="100%" height={260}>
                      <BarChart data={summary.topProducts} margin={{ top: 15, right: 20, left: -8, bottom: 40 }}>
                        <defs>
                          <linearGradient id="barGrad1" x1="0" y1="0" x2="0" y2="1">
                            <stop offset="5%" stopColor="#4f6ef7" stopOpacity={0.95} />
                            <stop offset="95%" stopColor="#3d52d5" stopOpacity={0.1} />
                          </linearGradient>
                        </defs>
                        <XAxis dataKey="product" tick={{ fill: "rgba(255,255,255,0.5)", fontSize: 11 }} axisLine={false} tickLine={false} angle={-45} textAnchor="end" height={80} />
                        <YAxis tick={{ fill: "rgba(255,255,255,0.5)", fontSize: 11 }} axisLine={false} tickLine={false} />
                        <Tooltip content={<CustomTooltip />} cursor={{ fill: "rgba(255,255,255,0.05)" }} />
                        <Bar dataKey="sold" fill="url(#barGrad1)" radius={[8, 8, 0, 0]} />
                      </BarChart>
                    </ResponsiveContainer>
                  ) : <div className="chart-empty">Sem dados</div>}
                </div>

                {/* Pedidos por Status */}
                <div className="chart-card animate-fadeUp fade-up-2">
                  <div className="chart-header">
                    <div className="chart-title">📊 Distribuição de Pedidos</div>
                    <span className="chart-meta">
                      {summary?.ordersByStatus?.length || 0} status
                    </span>
                  </div>
                  {summary?.ordersByStatus?.length > 0 ? (
                    <div style={{ display: "flex", justifyContent: "center" }}>
                      <ResponsiveContainer width="100%" height={260}>
                        <PieChart>
                          <Pie data={summary.ordersByStatus} dataKey="count" nameKey="status" cx="50%" cy="50%" outerRadius={85} innerRadius={55} paddingAngle={5}>
                            {summary.ordersByStatus.map((entry, i) => (
                              <Cell key={i} fill={STATUS_COLORS[entry.status] || "#a78bfa"} />
                            ))}
                          </Pie>
                          <Legend verticalAlign="bottom" height={30} formatter={(v) => <span style={{ color: "rgba(255,255,255,0.7)", fontSize: 12, fontWeight: 500 }}>{v}</span>} />
                          <Tooltip content={<CustomTooltip />} />
                        </PieChart>
                      </ResponsiveContainer>
                    </div>
                  ) : <div className="chart-empty">Sem dados de status</div>}
                </div>
              </div>

              {/* Full-width chart */}
              <div className="chart-card animate-fadeUp fade-up-3" style={{ marginTop: "var(--space-lg)" }}>
                <div className="chart-header">
                  <div className="chart-title">👥 Ranking de Clientes</div>
                  <span className="chart-meta">{summary?.ordersPerClient?.length || 0} clientes</span>
                </div>
                {summary?.ordersPerClient?.length > 0 ? (
                  <ResponsiveContainer width="100%" height={300}>
                    <BarChart data={summary.ordersPerClient} layout="vertical" margin={{ top: 15, right: 30, left: 160, bottom: 15 }}>
                      <defs>
                        <linearGradient id="barGrad2" x1="0" y1="0" x2="1" y2="0">
                          <stop offset="5%" stopColor="#06b6d4" stopOpacity={0.95} />
                          <stop offset="95%" stopColor="#4f6ef7" stopOpacity={0.1} />
                        </linearGradient>
                      </defs>
                      <XAxis type="number" tick={{ fill: "rgba(255,255,255,0.5)", fontSize: 11 }} axisLine={false} tickLine={false} />
                      <YAxis type="category" dataKey="client" tick={{ fill: "rgba(255,255,255,0.6)", fontSize: 11 }} axisLine={false} tickLine={false} width={150} />
                      <Tooltip content={<CustomTooltip />} cursor={{ fill: "rgba(255,255,255,0.05)" }} />
                      <Bar dataKey="orders" fill="url(#barGrad2)" radius={[0, 8, 8, 0]} />
                    </BarChart>
                  </ResponsiveContainer>
                ) : <div className="chart-empty">Sem dados</div>}
              </div>
            </section>
          </>
        )}
      </div>
    </div>
  );
};

export default Dashboard;
