import React, { useEffect, useState, useRef, useCallback } from "react";
import { useAuth } from "../contexts/AuthContext";
import api from "../services/api";
import { formatCurrency } from "../utils/formatCurrency";

// ─── Animated counter hook ────────────────────────────────────────────────────
function useCountUp(target, duration = 900, active = true) {
  const [value, setValue] = useState(0);
  useEffect(() => {
    if (!active || target === 0) { setValue(target); return; }
    const start = Date.now();
    const tick = () => {
      const p = Math.min(1, (Date.now() - start) / duration);
      const ease = 1 - Math.pow(1 - p, 3);
      setValue(Math.round(target * ease));
      if (p < 1) requestAnimationFrame(tick);
    };
    requestAnimationFrame(tick);
  }, [target, duration, active]);
  return value;
}

// ─── Sparkline SVG ────────────────────────────────────────────────────────────
const Sparkline = ({ color, inverted = false }) => {
  const pts = inverted
    ? "0,8 20,12 40,10 60,16 80,14 100,20 120,26"
    : "0,26 20,20 40,22 60,12 80,16 100,6 120,2";
  return (
    <svg viewBox="0 0 120 32" preserveAspectRatio="none" style={{ width: "100%", height: "32px", display: "block", marginTop: "12px" }}>
      <polyline
        points={pts}
        fill="none"
        stroke={color}
        strokeWidth="1.5"
        strokeLinecap="round"
        strokeLinejoin="round"
        style={{ strokeDasharray: 800, strokeDashoffset: 800, animation: "dashIn 1s ease forwards" }}
      />
    </svg>
  );
};

// ─── Donut chart ──────────────────────────────────────────────────────────────
const DonutChart = ({ data }) => {
  const cx = 50, cy = 50, r = 36, sw = 10;
  const total = data.reduce((a, b) => a + b.count, 0);
  if (!total) return null;
  let angle = -Math.PI / 2;
  const slices = data.map((d) => {
    const a = (d.count / total) * 2 * Math.PI;
    const x1 = cx + r * Math.cos(angle);
    const y1 = cy + r * Math.sin(angle);
    const x2 = cx + r * Math.cos(angle + a);
    const y2 = cy + r * Math.sin(angle + a);
    const large = a > Math.PI ? 1 : 0;
    const path = `M${x1.toFixed(2)},${y1.toFixed(2)} A${r},${r} 0 ${large},1 ${x2.toFixed(2)},${y2.toFixed(2)}`;
    angle += a;
    return { ...d, path };
  });
  return (
    <svg viewBox="0 0 100 100" style={{ width: "88px", height: "88px", flexShrink: 0 }}>
      {slices.map((s, i) => (
        <path key={i} d={s.path} fill="none" stroke={s.color} strokeWidth={sw} />
      ))}
      <text x="50" y="50" textAnchor="middle" dominantBaseline="central" style={{ fontSize: "13px", fontWeight: 700, fill: "#F0F0F8", fontFamily: "'JetBrains Mono',monospace" }}>
        {total}
      </text>
    </svg>
  );
};

// ─── Status config ────────────────────────────────────────────────────────────
const STATUS_COLOR = {
  pendente:  { bg: "rgba(247,145,106,0.12)", text: "#F7916A" },
  pago:      { bg: "rgba(0,212,170,0.12)",   text: "#00D4AA" },
  enviado:   { bg: "rgba(124,106,247,0.12)", text: "#7C6AF7" },
  entregue:  { bg: "rgba(0,212,170,0.12)",   text: "#00D4AA" },
  "concluído":{ bg: "rgba(0,212,170,0.12)",  text: "#00D4AA" },
  cancelado: { bg: "rgba(247,100,100,0.12)", text: "#F76464" },
  estornado: { bg: "rgba(122,122,154,0.12)", text: "#7A7A9A" },
  recusado:  { bg: "rgba(247,100,100,0.12)", text: "#F76464" },
};

const DONUT_COLORS = ["#00D4AA","#7C6AF7","#F7916A","#7A7A9A","#F76464","#85B7EB"];
const BAR_COLORS   = ["#7C6AF7","#00D4AA","#F7916A","#7C6AF7","#00D4AA"];

const AVATAR_COLORS = ["#7C6AF7","#00D4AA","#F7916A","#F76464","#85B7EB"];

// ─── Dashboard ────────────────────────────────────────────────────────────────
const Dashboard = () => {
  const { logout } = useAuth();
  const [summary, setSummary] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [dateRange, setDateRange] = useState({ from: "", to: "" });
  const [ready, setReady] = useState(false);

  const fetchSummary = useCallback(async () => {
    setLoading(true);
    setReady(false);
    setError("");
    try {
      const params =
        dateRange.from && dateRange.to
          ? { from: dateRange.from, to: dateRange.to }
          : {};
      const res = await api.get("/summary", { params });
      setSummary(res.data);
      setTimeout(() => setReady(true), 80);
    } catch (err) {
      if (err.response?.status === 401) { logout(); return; }
      setError("Falha ao carregar os dados do dashboard.");
    } finally {
      setLoading(false);
    }
  }, [dateRange, logout]);

  useEffect(() => { fetchSummary(); }, []);

  const totalOrders  = useCountUp(Number(summary?.totalOrders  ?? 0), 900, ready);
  const totalClients = useCountUp(Number(summary?.totalClients ?? 0), 900, ready);
  const totalSales   = Number(summary?.totalSales ?? 0);

  const donutData = (summary?.ordersByStatus ?? []).map((s, i) => ({
    ...s,
    color: DONUT_COLORS[i % DONUT_COLORS.length],
  }));

  const topProducts = summary?.topProducts ?? [];
  const maxSold     = Math.max(...topProducts.map((p) => Number(p.sold)), 1);

  const topClients  = (summary?.ordersPerClient ?? []).slice(0, 5);
  const recentOrders = [];

  return (
    <>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap');

        .db-root {
          --bg:       #0D0D12;
          --surface:  #13131A;
          --surface2: #1A1A24;
          --surface3: #22223A;
          --border:   rgba(255,255,255,0.06);
          --border2:  rgba(255,255,255,0.11);
          --text:     #F0F0F8;
          --muted:    #7A7A9A;
          --accent:   #7C6AF7;
          --teal:     #00D4AA;
          --coral:    #F7916A;
          --danger:   #F76464;
          --font:     'Space Grotesk', sans-serif;
          --mono:     'JetBrains Mono', monospace;
          min-height: 100vh;
          background: var(--bg);
          color: var(--text);
          font-family: var(--font);
          font-size: 14px;
        }

        @keyframes dashIn {
          to { stroke-dashoffset: 0; }
        }
        @keyframes fadeUp {
          from { opacity: 0; transform: translateY(14px); }
          to   { opacity: 1; transform: translateY(0); }
        }
        @keyframes barGrow {
          from { height: 0; }
        }

        .db-topbar {
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 20px 28px;
          border-bottom: 1px solid var(--border);
          flex-wrap: wrap;
          gap: 12px;
        }
        .db-page-title { font-size: 20px; font-weight: 700; letter-spacing: -0.5px; }
        .db-page-sub   { font-size: 12px; color: var(--muted); margin-top: 2px; }

        .db-date-row {
          display: flex;
          align-items: center;
          gap: 8px;
          flex-wrap: wrap;
        }
        .db-date-label { font-size: 12px; color: var(--muted); }
        .db-date-input {
          padding: 7px 11px;
          background: var(--surface2);
          border: 1px solid var(--border2);
          border-radius: 8px;
          color: var(--text);
          font-family: var(--font);
          font-size: 12px;
          outline: none;
          cursor: pointer;
          transition: border-color 150ms;
        }
        .db-date-input:focus { border-color: var(--accent); }
        .db-btn {
          padding: 7px 14px;
          background: var(--accent);
          border: none;
          border-radius: 8px;
          color: #fff;
          font-family: var(--font);
          font-size: 12px;
          font-weight: 600;
          cursor: pointer;
          transition: opacity 150ms;
        }
        .db-btn:hover { opacity: .85; }

        .db-body { padding: 24px 28px; display: flex; flex-direction: column; gap: 20px; }

        .db-kpi-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
          gap: 14px;
        }
        .db-kpi {
          background: var(--surface);
          border: 1px solid var(--border);
          border-radius: 14px;
          padding: 18px 20px;
          position: relative;
          overflow: hidden;
          animation: fadeUp .45s cubic-bezier(0.22,1,0.36,1) both;
        }
        .db-kpi:nth-child(1) { animation-delay: .04s; }
        .db-kpi:nth-child(2) { animation-delay: .09s; }
        .db-kpi:nth-child(3) { animation-delay: .14s; }
        .db-kpi-bar {
          position: absolute; top: 0; left: 0; right: 0; height: 2px;
        }
        .db-kpi-label {
          font-size: 11px; font-weight: 600; color: var(--muted);
          text-transform: uppercase; letter-spacing: 0.9px; margin-bottom: 10px;
        }
        .db-kpi-value {
          font-size: 30px; font-weight: 700; letter-spacing: -1.5px;
          line-height: 1; font-family: var(--mono);
        }
        .db-kpi-delta {
          display: inline-flex; align-items: center; gap: 4px;
          font-size: 11px; font-weight: 600;
          padding: 3px 8px; border-radius: 99px; margin-top: 10px;
        }
        .db-kpi-delta.up   { background: rgba(0,212,170,0.1);  color: var(--teal);   }
        .db-kpi-delta.down { background: rgba(247,100,100,0.1); color: var(--danger); }

        .db-charts-row {
          display: grid;
          grid-template-columns: 1.4fr 1fr;
          gap: 14px;
        }
        @media (max-width: 900px) { .db-charts-row { grid-template-columns: 1fr; } }

        .db-card {
          background: var(--surface);
          border: 1px solid var(--border);
          border-radius: 14px;
          padding: 20px;
          animation: fadeUp .45s cubic-bezier(0.22,1,0.36,1) .2s both;
        }
        .db-card-header {
          display: flex; align-items: center; justify-content: space-between;
          margin-bottom: 18px;
        }
        .db-card-title { font-size: 13px; font-weight: 600; }
        .db-card-badge {
          font-size: 11px; padding: 3px 8px;
          background: var(--surface2); border-radius: 6px; color: var(--muted);
        }

        .db-bars {
          display: flex; align-items: flex-end; gap: 8px; height: 120px; padding-top: 8px;
        }
        .db-bar-wrap { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 6px; height: 100%; justify-content: flex-end; }
        .db-bar {
          width: 100%; border-radius: 4px 4px 0 0;
          animation: barGrow .6s cubic-bezier(0.22,1,0.36,1) both;
          transition: opacity 150ms;
        }
        .db-bar:nth-child(1) { animation-delay: .1s; }
        .db-bar:nth-child(2) { animation-delay: .15s; }
        .db-bar:nth-child(3) { animation-delay: .2s; }
        .db-bar:nth-child(4) { animation-delay: .25s; }
        .db-bar:nth-child(5) { animation-delay: .3s; }
        .db-bar:hover { opacity: .7; }
        .db-bar-label { font-size: 10px; color: var(--muted); text-align: center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; width: 100%; }

        .db-donut-wrap { display: flex; align-items: center; gap: 18px; }
        .db-donut-legend { display: flex; flex-direction: column; gap: 9px; flex: 1; min-width: 0; }
        .db-legend-item { display: flex; align-items: center; gap: 8px; font-size: 12px; }
        .db-legend-dot { width: 7px; height: 7px; border-radius: 50%; flex-shrink: 0; }
        .db-legend-name { color: var(--muted); flex: 1; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .db-legend-val { font-weight: 600; font-family: var(--mono); }

        .db-bottom-row {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 14px;
        }
        @media (max-width: 750px) { .db-bottom-row { grid-template-columns: 1fr; } }

        .db-list-item {
          display: flex; align-items: center; gap: 12px;
          padding: 10px 0; border-bottom: 1px solid var(--border);
        }
        .db-list-item:last-child { border-bottom: none; padding-bottom: 0; }
        .db-avatar {
          width: 34px; height: 34px; border-radius: 9px;
          display: flex; align-items: center; justify-content: center;
          font-size: 11px; font-weight: 700; flex-shrink: 0;
        }
        .db-list-info { flex: 1; min-width: 0; }
        .db-list-name { font-size: 13px; font-weight: 500; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .db-list-sub  { font-size: 11px; color: var(--muted); margin-top: 1px; }
        .db-list-val  { font-size: 13px; font-weight: 600; font-family: var(--mono); flex-shrink: 0; }
        .db-status-pill {
          font-size: 10px; font-weight: 600;
          padding: 3px 9px; border-radius: 99px;
          white-space: nowrap; flex-shrink: 0;
        }

        .db-empty {
          display: flex; flex-direction: column; align-items: center;
          justify-content: center; padding: 32px; color: var(--muted); gap: 8px;
        }
        .db-empty-icon { font-size: 28px; opacity: .5; }
        .db-empty-text { font-size: 13px; }

        .db-skeleton {
          background: linear-gradient(90deg, var(--surface2) 0%, var(--surface3) 50%, var(--surface2) 100%);
          background-size: 200% 100%;
          animation: shimmer 1.4s ease-in-out infinite;
          border-radius: 8px;
        }
        @keyframes shimmer {
          0%   { background-position: 200% 0; }
          100% { background-position: -200% 0; }
        }

        .db-error {
          margin: 40px auto; text-align: center;
          color: var(--danger); font-size: 14px;
        }
      `}</style>

      <div className="db-root">
        {/* Topbar */}
        <div className="db-topbar">
          <div>
            <div className="db-page-title">Dashboard</div>
            <div className="db-page-sub">Visão geral do negócio</div>
          </div>
          <div className="db-date-row">
            <span className="db-date-label">De</span>
            <input
              type="date"
              className="db-date-input"
              value={dateRange.from}
              onChange={(e) => setDateRange((p) => ({ ...p, from: e.target.value }))}
            />
            <span className="db-date-label">até</span>
            <input
              type="date"
              className="db-date-input"
              value={dateRange.to}
              onChange={(e) => setDateRange((p) => ({ ...p, to: e.target.value }))}
            />
            <button className="db-btn" onClick={fetchSummary}>
              Aplicar
            </button>
          </div>
        </div>

        {/* Body */}
        <div className="db-body">
          {error && <div className="db-error">{error}</div>}

          {/* KPI cards */}
          <div className="db-kpi-grid">
            {/* Pedidos */}
            <div className="db-kpi">
              <div className="db-kpi-bar" style={{ background: "var(--accent)" }} />
              <div className="db-kpi-label">Total de pedidos</div>
              {loading
                ? <div className="db-skeleton" style={{ height: 30, width: 80 }} />
                : <div className="db-kpi-value">{totalOrders.toLocaleString("pt-BR")}</div>
              }
              <div className="db-kpi-delta up">↑ período atual</div>
              <Sparkline color="var(--accent)" />
            </div>

            {/* Receita */}
            <div className="db-kpi">
              <div className="db-kpi-bar" style={{ background: "var(--teal)" }} />
              <div className="db-kpi-label">Receita total</div>
              {loading
                ? <div className="db-skeleton" style={{ height: 30, width: 120 }} />
                : <div className="db-kpi-value">{formatCurrency(totalSales)}</div>
              }
              <div className="db-kpi-delta up">↑ período atual</div>
              <Sparkline color="var(--teal)" />
            </div>

            {/* Clientes */}
            <div className="db-kpi">
              <div className="db-kpi-bar" style={{ background: "var(--coral)" }} />
              <div className="db-kpi-label">Clientes ativos</div>
              {loading
                ? <div className="db-skeleton" style={{ height: 30, width: 60 }} />
                : <div className="db-kpi-value">{totalClients.toLocaleString("pt-BR")}</div>
              }
              <div className="db-kpi-delta up">↑ período atual</div>
              <Sparkline color="var(--coral)" inverted />
            </div>
          </div>

          {/* Charts row */}
          <div className="db-charts-row">
            {/* Bar chart */}
            <div className="db-card">
              <div className="db-card-header">
                <span className="db-card-title">Produtos mais vendidos</span>
                <span className="db-card-badge">Top {topProducts.length}</span>
              </div>
              {loading ? (
                <div style={{ display: "flex", gap: 8, alignItems: "flex-end", height: 120 }}>
                  {[60,90,45,75,30].map((h,i) => (
                    <div key={i} className="db-skeleton" style={{ flex: 1, height: h }} />
                  ))}
                </div>
              ) : topProducts.length === 0 ? (
                <div className="db-empty">
                  <div className="db-empty-icon">📦</div>
                  <div className="db-empty-text">Nenhum produto vendido ainda</div>
                </div>
              ) : (
                <div className="db-bars">
                  {topProducts.map((p, i) => {
                    const pct = Math.round((Number(p.sold) / maxSold) * 100);
                    return (
                      <div key={i} className="db-bar-wrap">
                        <div
                          className="db-bar"
                          style={{
                            height: `${pct}%`,
                            background: BAR_COLORS[i % BAR_COLORS.length],
                            opacity: 0.4 + 0.6 * (pct / 100),
                          }}
                          title={`${p.product}: ${p.sold} vendidos`}
                        />
                        <div className="db-bar-label">{p.product}</div>
                      </div>
                    );
                  })}
                </div>
              )}
            </div>

            {/* Donut */}
            <div className="db-card">
              <div className="db-card-header">
                <span className="db-card-title">Pedidos por status</span>
                <span className="db-card-badge">Distribuição</span>
              </div>
              {loading ? (
                <div style={{ display: "flex", gap: 16, alignItems: "center" }}>
                  <div className="db-skeleton" style={{ width: 88, height: 88, borderRadius: "50%", flexShrink: 0 }} />
                  <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: 8 }}>
                    {[1,2,3,4].map(i => <div key={i} className="db-skeleton" style={{ height: 14 }} />)}
                  </div>
                </div>
              ) : donutData.length === 0 ? (
                <div className="db-empty">
                  <div className="db-empty-icon">📊</div>
                  <div className="db-empty-text">Sem pedidos no período</div>
                </div>
              ) : (
                <div className="db-donut-wrap">
                  <DonutChart data={donutData} />
                  <div className="db-donut-legend">
                    {donutData.map((s, i) => (
                      <div key={i} className="db-legend-item">
                        <div className="db-legend-dot" style={{ background: s.color }} />
                        <span className="db-legend-name">{s.status}</span>
                        <span className="db-legend-val">{s.count}</span>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Bottom row */}
          <div className="db-bottom-row">
            {/* Top clientes */}
            <div className="db-card" style={{ animationDelay: ".3s" }}>
              <div className="db-card-header">
                <span className="db-card-title">Top clientes</span>
                <span className="db-card-badge">{topClients.length} clientes</span>
              </div>
              {loading ? (
                <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
                  {[1,2,3,4].map(i => (
                    <div key={i} style={{ display: "flex", gap: 10, alignItems: "center" }}>
                      <div className="db-skeleton" style={{ width: 34, height: 34, borderRadius: 9, flexShrink: 0 }} />
                      <div style={{ flex: 1 }}>
                        <div className="db-skeleton" style={{ height: 13, marginBottom: 4 }} />
                        <div className="db-skeleton" style={{ height: 11, width: "60%" }} />
                      </div>
                    </div>
                  ))}
                </div>
              ) : topClients.length === 0 ? (
                <div className="db-empty">
                  <div className="db-empty-icon">👥</div>
                  <div className="db-empty-text">Nenhum cliente com pedidos</div>
                </div>
              ) : (
                topClients.map((c, i) => {
                  const initials = c.client.split(" ").map((w) => w[0]).slice(0, 2).join("").toUpperCase();
                  const color = AVATAR_COLORS[i % AVATAR_COLORS.length];
                  return (
                    <div key={i} className="db-list-item">
                      <div
                        className="db-avatar"
                        style={{ background: color + "22", color }}
                      >
                        {initials}
                      </div>
                      <div className="db-list-info">
                        <div className="db-list-name">{c.client}</div>
                        <div className="db-list-sub">{c.orders} {Number(c.orders) === 1 ? "pedido" : "pedidos"}</div>
                      </div>
                      <div className="db-list-val">{c.orders}</div>
                    </div>
                  );
                })
              )}
            </div>

            {/* Status breakdown detalhado */}
            <div className="db-card" style={{ animationDelay: ".35s" }}>
              <div className="db-card-header">
                <span className="db-card-title">Breakdown de status</span>
              </div>
              {loading ? (
                <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
                  {[1,2,3,4].map(i => <div key={i} className="db-skeleton" style={{ height: 36 }} />)}
                </div>
              ) : donutData.length === 0 ? (
                <div className="db-empty">
                  <div className="db-empty-icon">📋</div>
                  <div className="db-empty-text">Sem dados no período</div>
                </div>
              ) : (
                donutData.map((s, i) => {
                  const sc = STATUS_COLOR[s.status] ?? { bg: "rgba(122,122,154,0.12)", text: "#7A7A9A" };
                  const total = donutData.reduce((a, b) => a + b.count, 0);
                  const pct = total ? Math.round((s.count / total) * 100) : 0;
                  return (
                    <div key={i} className="db-list-item">
                      <div className="db-list-info">
                        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 6 }}>
                          <span className="db-status-pill" style={{ background: sc.bg, color: sc.text }}>
                            {s.status}
                          </span>
                          <span style={{ fontSize: 12, fontFamily: "var(--mono)", fontWeight: 600 }}>
                            {s.count} <span style={{ color: "var(--muted)", fontWeight: 400 }}>({pct}%)</span>
                          </span>
                        </div>
                        <div style={{ height: 4, background: "var(--surface3)", borderRadius: 99, overflow: "hidden" }}>
                          <div style={{
                            height: "100%", width: `${pct}%`, background: s.color,
                            borderRadius: 99, transition: "width 800ms cubic-bezier(0.22,1,0.36,1)",
                          }} />
                        </div>
                      </div>
                    </div>
                  );
                })
              )}
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Dashboard;