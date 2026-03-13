import React, { useEffect, useState } from "react";
import { useAuth } from "../contexts/AuthContext";
import api from "../services/api";
import {
  BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer,
  PieChart, Pie, Cell, Legend,
} from "recharts";

const COLORS = ["#4f6ef7", "#06b6d4", "#a78bfa", "#f59e0b"];

/* ─── Custom Tooltip ─── */
const CustomTooltip = ({ active, payload, label }) => {
  if (active && payload && payload.length) {
    return (
      <div style={{
        background: "#17171f", border: "1px solid rgba(255,255,255,0.08)",
        borderRadius: 8, padding: "10px 14px", fontFamily: "'DM Sans',sans-serif",
        fontSize: 13, color: "#e8e8f0",
      }}>
        <div style={{ color: "rgba(255,255,255,0.45)", marginBottom: 4 }}>{label}</div>
        {payload.map((p, i) => (
          <div key={i} style={{ color: p.color || "#4f6ef7", fontWeight: 600 }}>
            {p.name}: {p.value}
          </div>
        ))}
      </div>
    );
  }
  return null;
};

/* ─── Dashboard page ─── */
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
    { icon: "📦", label: "Total de Pedidos", value: totalOrders, accent: "#4f6ef7", delay: "fade-up-1" },
    { icon: "👥", label: "Clientes Ativos", value: totalClients, accent: "#06b6d4", delay: "fade-up-2" },
    { icon: "💰", label: "Receita Total", value: `R$ ${totalRevenue}`, accent: "#a78bfa", delay: "fade-up-3" },
  ];

  return (
    <div className="main-content">
          <div className="topbar">
            <div className="topbar-title">Dashboard</div>
            <div className="topbar-right">
              <div className="date-filter">
                <span className="date-label">De</span>
                <input type="date" className="date-input" value={dateRange.from}
                  onChange={(e) => setDateRange({ ...dateRange, from: e.target.value })} />
                <span className="date-label">Até</span>
                <input type="date" className="date-input" value={dateRange.to}
                  onChange={(e) => setDateRange({ ...dateRange, to: e.target.value })} />
                <button className="btn btn-primary btn-sm" onClick={() => { setLoading(true); fetchSummary(); }}>
                  Filtrar
                </button>
              </div>
            </div>
          </div>

          <div className="page-body">
            {loading ? (
              <div className="loading-center">
                <div className="spinner-ring" />
                <span>Carregando dados...</span>
              </div>
            ) : error ? (
              <div className="empty-state">
                <div className="empty-state-icon">⚠️</div>
                <div className="empty-state-text" style={{ color: "#f87171" }}>{error}</div>
              </div>
            ) : (
              <>
                {/* Stat cards */}
                <div className="stat-grid">
                  {STAT_CARDS.map((card) => (
                    <div key={card.label} className={`stat-card animate-fadeUp`}>
                      <div className="stat-accent-line" style={{ background: card.accent }} />
                      <span className="stat-card-icon">{card.icon}</span>
                      <div className="stat-card-label">{card.label}</div>
                      <div className="stat-card-value">{card.value}</div>
                    </div>
                  ))}
                </div>

                {/* Charts */}
                <div className="charts-grid">
                  <div className="chart-card animate-fadeUp">
                    <div className="chart-title">Produtos em Estoque</div>
                    <ResponsiveContainer width="100%" height={220}>
                      <BarChart data={summary?.topProducts || []} margin={{ top: 0, right: 0, left: -20, bottom: 0 }}>
                        <XAxis dataKey="product" tick={{ fill: "rgba(255,255,255,0.35)", fontSize: 12 }} axisLine={false} tickLine={false} />
                        <YAxis tick={{ fill: "rgba(255,255,255,0.35)", fontSize: 12 }} axisLine={false} tickLine={false} />
                        <Tooltip content={<CustomTooltip />} cursor={{ fill: "rgba(255,255,255,0.03)" }} />
                        <Bar dataKey="sold" fill="#4f6ef7" radius={[4, 4, 0, 0]} />
                      </BarChart>
                    </ResponsiveContainer>
                  </div>

                  <div className="chart-card animate-fadeUp">
                    <div className="chart-title">Pedidos por Status</div>
                    {summary?.ordersByStatus?.length > 0 ? (
                      <ResponsiveContainer width="100%" height={220}>
                        <PieChart>
                          <Pie data={summary.ordersByStatus} dataKey="count" nameKey="status"
                            cx="50%" cy="50%" outerRadius={70} innerRadius={40} paddingAngle={3}>
                            {summary.ordersByStatus.map((_, i) => (
                              <Cell key={i} fill={COLORS[i % COLORS.length]} />
                            ))}
                          </Pie>
                          <Legend verticalAlign="bottom" iconType="circle" iconSize={8}
                            formatter={(v) => <span style={{ color: "rgba(255,255,255,0.5)", fontSize: 12 }}>{v}</span>} />
                          <Tooltip content={<CustomTooltip />} />
                        </PieChart>
                      </ResponsiveContainer>
                    ) : (
                      <div className="empty-state">
                        <div className="empty-state-icon">📊</div>
                        <div className="empty-state-text">Sem dados disponíveis</div>
                      </div>
                    )}
                  </div>

                  <div className="chart-card span-2 fade-up fade-up-5">
                    <div className="chart-title">Pedidos por Cliente</div>
                    <ResponsiveContainer width="100%" height={220}>
                      <BarChart data={summary?.ordersPerClient || []} margin={{ top: 0, right: 0, left: -20, bottom: 0 }}>
                        <XAxis dataKey="client" tick={{ fill: "rgba(255,255,255,0.35)", fontSize: 12 }} axisLine={false} tickLine={false} />
                        <YAxis tick={{ fill: "rgba(255,255,255,0.35)", fontSize: 12 }} axisLine={false} tickLine={false} />
                        <Tooltip content={<CustomTooltip />} cursor={{ fill: "rgba(255,255,255,0.03)" }} />
                        <Bar dataKey="orders" fill="#06b6d4" radius={[4, 4, 0, 0]} />
                      </BarChart>
                    </ResponsiveContainer>
                  </div>
                </div>
              </>
            )}
          </div>
        </div>
  );
};

export default Dashboard;
