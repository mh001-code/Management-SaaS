import React, { useEffect, useState, useCallback } from "react";
import { useAuth } from "../contexts/AuthContext";
import api from "../services/api";
import { formatCurrency } from "../utils/formatCurrency";
import {
  LineChart, Line, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer,
} from "recharts";

function useCountUp(target, duration = 900, active = true) {
  const [value, setValue] = useState(0);
  useEffect(() => {
    if (!active || target === 0) { setValue(target); return; }
    const start = Date.now();
    const tick = () => {
      const p = Math.min(1, (Date.now() - start) / duration);
      setValue(Math.round(target * (1 - Math.pow(1 - p, 3))));
      if (p < 1) requestAnimationFrame(tick);
    };
    requestAnimationFrame(tick);
  }, [target, duration, active]);
  return value;
}

const STATUS_STYLE = {
  pendente:    { bg: "rgba(247,145,106,0.12)", text: "#F7916A" },
  pago:        { bg: "rgba(0,212,170,0.12)",   text: "#00D4AA" },
  enviado:     { bg: "rgba(124,106,247,0.12)", text: "#7C6AF7" },
  entregue:    { bg: "rgba(0,212,170,0.12)",   text: "#00D4AA" },
  "concluído": { bg: "rgba(0,212,170,0.12)",   text: "#00D4AA" },
  cancelado:   { bg: "rgba(247,100,100,0.12)", text: "#F76464" },
  estornado:   { bg: "rgba(122,122,154,0.12)", text: "#7A7A9A" },
  recusado:    { bg: "rgba(247,100,100,0.12)", text: "#F76464" },
};

const DONUT_COLORS  = ["#00D4AA","#7C6AF7","#F7916A","#7A7A9A","#F76464","#85B7EB"];
const AVATAR_COLORS = ["#7C6AF7","#00D4AA","#F7916A","#F76464","#85B7EB"];

const DonutChart = ({ data }) => {
  const cx = 50, cy = 50, r = 36, sw = 10;
  const total = data.reduce((a, b) => a + b.count, 0);
  if (!total) return null;
  let angle = -Math.PI / 2;
  const slices = data.map((d) => {
    const a = (d.count / total) * 2 * Math.PI;
    const x1 = cx + r * Math.cos(angle), y1 = cy + r * Math.sin(angle);
    const x2 = cx + r * Math.cos(angle + a), y2 = cy + r * Math.sin(angle + a);
    const large = a > Math.PI ? 1 : 0;
    const path = `M${x1.toFixed(2)},${y1.toFixed(2)} A${r},${r} 0 ${large},1 ${x2.toFixed(2)},${y2.toFixed(2)}`;
    angle += a;
    return { ...d, path };
  });
  return (
    <svg viewBox="0 0 100 100" style={{ width: 80, height: 80, flexShrink: 0 }}>
      {slices.map((s, i) => <path key={i} d={s.path} fill="none" stroke={s.color} strokeWidth={sw} />)}
      <text x="50" y="50" textAnchor="middle" dominantBaseline="central"
        style={{ fontSize: 12, fontWeight: 700, fill: "var(--color-text)", fontFamily: "monospace" }}>
        {total}
      </text>
    </svg>
  );
};

const LineTooltip = ({ active, payload, label }) => {
  if (!active || !payload?.length) return null;
  return (
    <div style={{ background: "var(--color-surface2)", border: "1px solid var(--color-border2)",
      borderRadius: 8, padding: "10px 14px", fontSize: 12 }}>
      <div style={{ color: "var(--color-textMuted)", marginBottom: 6, fontWeight: 600 }}>{label}</div>
      <div style={{ color: "var(--color-teal)", fontWeight: 700 }}>{formatCurrency(payload[0]?.value ?? 0)}</div>
    </div>
  );
};

const SkBox = ({ w = "100%", h = 14 }) => (
  <div style={{ width: w, height: h, borderRadius: 6,
    backgroundImage: "linear-gradient(90deg,var(--color-surface2) 0%,var(--color-surface3) 50%,var(--color-surface2) 100%)",
    backgroundSize: "200% 100%", animation: "shimmer 1.4s ease-in-out infinite" }} />
);

const Dashboard = () => {
  const { logout } = useAuth();
  const [summary, setSummary]     = useState(null);
  const [loading, setLoading]     = useState(true);
  const [error, setError]         = useState("");
  const [dateRange, setDateRange] = useState({ from: "", to: "" });
  const [ready, setReady]         = useState(false);

  const fetchSummary = useCallback(async () => {
    setLoading(true); setReady(false); setError("");
    try {
      const params = dateRange.from && dateRange.to ? { from: dateRange.from, to: dateRange.to } : {};
      const res = await api.get("/summary", { params });
      setSummary(res.data);
      setTimeout(() => setReady(true), 80);
    } catch (err) {
      if (err.response?.status === 401) { logout(); return; }
      setError("Falha ao carregar os dados do dashboard.");
    } finally { setLoading(false); }
  }, [dateRange, logout]);

  useEffect(() => { fetchSummary(); }, []);

  const totalOrders  = useCountUp(Number(summary?.totalOrders  ?? 0), 900, ready);
  const totalClients = useCountUp(Number(summary?.totalClients ?? 0), 900, ready);
  const totalSales   = Number(summary?.totalSales ?? 0);
  const avgTicket    = Number(summary?.avgTicket  ?? 0);
  const fin          = summary?.financialSummary ?? {};

  const donutData      = (summary?.ordersByStatus  ?? []).map((s, i) => ({ ...s, color: DONUT_COLORS[i % DONUT_COLORS.length] }));
  const topProducts    = summary?.topProducts    ?? [];
  const topClients     = (summary?.ordersPerClient ?? []).slice(0, 5);
  const revenueByMonth = summary?.revenueByMonth ?? [];
  const recentOrders   = summary?.recentOrders   ?? [];
  const lowStock       = summary?.lowStock       ?? [];
  const maxSold        = Math.max(...topProducts.map((p) => Number(p.sold)), 1);

  const saldoPositivo = Number(fin.saldo ?? 0) >= 0;

  return (
    <>
      <style>{`
        @keyframes shimmer { 0%{background-position:200% 0} 100%{background-position:-200% 0} }
        @keyframes fadeUp  { from{opacity:0;transform:translateY(14px)} to{opacity:1;transform:translateY(0)} }
        @keyframes barGrow { from{height:0} }
        .db { --bg:var(--color-bg);--s1:var(--color-surface);--s2:var(--color-surface2);--s3:var(--color-surface3);
              --b1:var(--color-border);--b2:var(--color-border2);
              --text:var(--color-text);--muted:var(--color-textMuted);
              --accent:var(--color-primary);--teal:var(--color-teal);--coral:var(--color-coral);--danger:var(--color-danger);
              min-height:100vh;background:var(--bg);color:var(--text);
              font-family:'Space Grotesk',sans-serif;font-size:14px; }
        .db-topbar { display:flex;align-items:center;justify-content:space-between;
          padding:24px 32px;border-bottom:1px solid var(--b1);flex-wrap:wrap;gap:14px; }
        .db-page-title { font-size:22px;font-weight:700;letter-spacing:-0.6px; }
        .db-page-sub   { font-size:12px;color:var(--muted);margin-top:3px; }
        .db-date-row   { display:flex;align-items:center;gap:10px;flex-wrap:wrap; }
        .db-date-label { font-size:12px;color:var(--muted); }
        .db-date-input { padding:8px 12px;background:var(--s2);border:1px solid var(--b2);
          border-radius:8px;color:var(--text);font-family:inherit;font-size:12px;
          outline:none;cursor:pointer;transition:border-color 150ms; }
        .db-date-input:focus { border-color:var(--accent); }
        .db-btn { padding:8px 16px;background:var(--accent);border:none;border-radius:8px;
          color:#fff;font-family:inherit;font-size:12px;font-weight:600;cursor:pointer; }
        .db-btn:hover { opacity:.85; }
        .db-body { padding:28px 32px;display:flex;flex-direction:column;gap:24px; }
        .db-kpi-grid { display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px; }
        .db-kpi { background:var(--s1);border:1px solid var(--b1);border-radius:14px;
          padding:20px 22px;position:relative;overflow:hidden;
          animation:fadeUp .45s cubic-bezier(0.22,1,0.36,1) both; }
        .db-kpi:nth-child(1){animation-delay:.04s} .db-kpi:nth-child(2){animation-delay:.08s}
        .db-kpi:nth-child(3){animation-delay:.12s} .db-kpi:nth-child(4){animation-delay:.16s}
        .db-kpi-bar { position:absolute;top:0;left:0;right:0;height:2px; }
        .db-kpi-label { font-size:11px;font-weight:600;color:var(--muted);
          text-transform:uppercase;letter-spacing:.9px;margin-bottom:10px; }
        .db-kpi-value { font-size:26px;font-weight:700;letter-spacing:-1px;line-height:1;
          font-family:'JetBrains Mono',monospace; }
        .db-kpi-sub { font-size:11px;color:var(--muted);margin-top:8px; }
        .db-section-title { font-size:11px;font-weight:600;color:var(--muted);
          text-transform:uppercase;letter-spacing:1px;margin-bottom:12px; }
        .db-row { display:grid;gap:16px; }
        .db-row-2-1 { grid-template-columns:1.5fr 1fr; }
        .db-row-1-1 { grid-template-columns:1fr 1fr; }
        @media(max-width:900px){.db-row-2-1,.db-row-1-1{grid-template-columns:1fr}}
        .db-card { background:var(--s1);border:1px solid var(--b1);border-radius:14px;
          padding:22px;animation:fadeUp .45s cubic-bezier(0.22,1,0.36,1) .18s both; }
        .db-card-header { display:flex;align-items:center;justify-content:space-between;margin-bottom:18px; }
        .db-card-title  { font-size:13px;font-weight:600; }
        .db-card-badge  { font-size:11px;padding:3px 9px;background:var(--s2);border-radius:6px;color:var(--muted); }
        .db-bars { display:flex;align-items:flex-end;gap:10px;height:110px;padding-top:8px; }
        .db-bar-wrap { flex:1;display:flex;flex-direction:column;align-items:center;gap:6px;height:100%;justify-content:flex-end; }
        .db-bar { width:100%;border-radius:4px 4px 0 0;transition:opacity 150ms;animation:barGrow .6s cubic-bezier(0.22,1,0.36,1) both; }
        .db-bar:hover { opacity:.7; }
        .db-bar-label { font-size:10px;color:var(--muted);text-align:center;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width:100%; }
        .db-donut-wrap   { display:flex;align-items:center;gap:20px; }
        .db-donut-legend { display:flex;flex-direction:column;gap:10px;flex:1;min-width:0; }
        .db-legend-item  { display:flex;align-items:center;gap:8px;font-size:12px; }
        .db-legend-dot   { width:7px;height:7px;border-radius:50%;flex-shrink:0; }
        .db-legend-name  { color:var(--muted);flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap; }
        .db-legend-val   { font-weight:600;font-family:'JetBrains Mono',monospace;font-size:12px; }
        .db-list-item { display:flex;align-items:center;gap:12px;padding:10px 0;border-bottom:1px solid var(--b1); }
        .db-list-item:last-child { border-bottom:none;padding-bottom:0; }
        .db-avatar { width:32px;height:32px;border-radius:9px;display:flex;align-items:center;
          justify-content:center;font-size:11px;font-weight:700;flex-shrink:0; }
        .db-list-info { flex:1;min-width:0; }
        .db-list-name { font-size:13px;font-weight:500;white-space:nowrap;overflow:hidden;text-overflow:ellipsis; }
        .db-list-sub  { font-size:11px;color:var(--muted);margin-top:1px; }
        .db-list-val  { font-size:13px;font-weight:600;font-family:'JetBrains Mono',monospace;flex-shrink:0; }
        .db-status { font-size:10px;font-weight:600;padding:3px 9px;border-radius:99px;white-space:nowrap;flex-shrink:0; }
        .db-stock-badge { font-size:11px;font-weight:700;font-family:'JetBrains Mono',monospace;padding:3px 8px;border-radius:6px;flex-shrink:0; }
        .db-stock-zero { background:rgba(247,100,100,.12);color:#F76464; }
        .db-stock-low  { background:rgba(247,145,106,.12);color:#F7916A; }
        .db-empty { display:flex;flex-direction:column;align-items:center;justify-content:center;padding:32px;color:var(--muted);gap:8px; }
        .db-empty-icon { font-size:24px;opacity:.5; }
        .db-empty-text { font-size:13px; }
        .db-error-banner { display:flex;align-items:center;gap:10px;padding:12px 16px;
          background:rgba(247,100,100,.07);border:1px solid rgba(247,100,100,.2);
          border-radius:10px;color:#F76464;font-size:13px; }
        .recharts-cartesian-grid-horizontal line,
        .recharts-cartesian-grid-vertical   line { stroke:var(--color-border) !important; }
        .recharts-xAxis .recharts-tick text,
        .recharts-yAxis .recharts-tick text { fill:var(--color-textMuted) !important;font-size:11px !important; }
      `}</style>

      <div className="db">
        {/* Topbar */}
        <div className="db-topbar">
          <div>
            <div className="db-page-title">Dashboard</div>
            <div className="db-page-sub">Visão geral do negócio</div>
          </div>
          <div className="db-date-row">
            <span className="db-date-label">De</span>
            <input type="date" className="db-date-input" value={dateRange.from}
              onChange={(e) => setDateRange((p) => ({ ...p, from: e.target.value }))} />
            <span className="db-date-label">até</span>
            <input type="date" className="db-date-input" value={dateRange.to}
              onChange={(e) => setDateRange((p) => ({ ...p, to: e.target.value }))} />
            <button className="db-btn" onClick={fetchSummary}>Aplicar</button>
          </div>
        </div>

        <div className="db-body">
          {error && (
            <div className="db-error-banner">
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <circle cx="8" cy="8" r="7" stroke="currentColor" strokeWidth="1.5"/>
                <path d="M8 5v3.5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
                <circle cx="8" cy="11" r=".75" fill="currentColor"/>
              </svg>
              {error}
            </div>
          )}

          {/* ── KPIs de pedidos ── */}
          <div>
            <div className="db-section-title">Pedidos</div>
            <div className="db-kpi-grid">
              {[
                { label: "Total de pedidos", value: loading ? null : totalOrders.toLocaleString("pt-BR"), sub: "período selecionado", color: "#7C6AF7" },
                { label: "Receita bruta",    value: loading ? null : formatCurrency(totalSales),          sub: "soma dos pedidos",   color: "#00D4AA", sm: true },
                { label: "Ticket médio",     value: loading ? null : formatCurrency(avgTicket),            sub: "por pedido",         color: "#F7916A", sm: true },
                { label: "Clientes ativos",  value: loading ? null : totalClients.toLocaleString("pt-BR"),sub: "total cadastrado",   color: "#85B7EB" },
              ].map((k, i) => (
                <div key={i} className="db-kpi">
                  <div className="db-kpi-bar" style={{ background: k.color }} />
                  <div className="db-kpi-label">{k.label}</div>
                  {k.value === null ? <SkBox h={26} w={k.sm ? 120 : 80} />
                    : <div className="db-kpi-value" style={k.sm ? { fontSize: 20 } : {}}>{k.value}</div>}
                  <div className="db-kpi-sub">{k.sub}</div>
                </div>
              ))}
            </div>
          </div>

          {/* ── KPIs financeiros ── */}
          <div>
            <div className="db-section-title">Financeiro</div>
            <div className="db-kpi-grid">
              {[
                { label: "Receitas pagas",  value: loading ? null : formatCurrency(fin.receitaPaga ?? 0), sub: "lançamentos pagos",  color: "#00D4AA", sm: true },
                { label: "Despesas pagas",  value: loading ? null : formatCurrency(fin.despesaPaga ?? 0), sub: "lançamentos pagos",  color: "#F76464", sm: true },
                { label: "Saldo",           value: loading ? null : formatCurrency(fin.saldo ?? 0),       sub: "receitas − despesas",color: saldoPositivo ? "#00D4AA" : "#F76464", sm: true },
                { label: "A vencer",        value: loading ? null : formatCurrency(fin.totalAVencer ?? 0),sub: "vencimento futuro",   color: "#F7916A", sm: true },
                { label: "Vencido",           value: loading ? null : formatCurrency(fin.totalVencido ?? 0),sub: "prazo ultrapassado",  color: "#F76464", sm: true },
              ].map((k, i) => (
                <div key={i} className="db-kpi" style={{ animationDelay: `${0.04 + i * 0.04}s` }}>
                  <div className="db-kpi-bar" style={{ background: k.color }} />
                  <div className="db-kpi-label">{k.label}</div>
                  {k.value === null ? <SkBox h={26} w={120} />
                    : <div className="db-kpi-value" style={{ fontSize: 20, color: k.color }}>{k.value}</div>}
                  <div className="db-kpi-sub">{k.sub}</div>
                </div>
              ))}
            </div>
          </div>

          {/* ── Alerta estoque baixo ── */}
          {!loading && lowStock.length > 0 && (
            <div style={{ background: "var(--s1)", border: "1px solid rgba(247,145,106,0.2)",
              borderRadius: 14, padding: "18px 22px", animation: "fadeUp .45s cubic-bezier(0.22,1,0.36,1) .1s both" }}>
              <div className="db-card-header" style={{ marginBottom: 14 }}>
                <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                  <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
                    <path d="M8 2L14.5 13H1.5L8 2Z" stroke="#F7916A" strokeWidth="1.5" strokeLinejoin="round"/>
                    <path d="M8 6v3" stroke="#F7916A" strokeWidth="1.5" strokeLinecap="round"/>
                    <circle cx="8" cy="11" r=".75" fill="#F7916A"/>
                  </svg>
                  <span className="db-card-title" style={{ color: "#F7916A" }}>Estoque baixo</span>
                </div>
                <span className="db-card-badge">{lowStock.length} produto{lowStock.length !== 1 ? "s" : ""}</span>
              </div>
              <div style={{ display: "flex", flexWrap: "wrap", gap: 8 }}>
                {lowStock.map((p) => (
                  <div key={p.id} style={{ display: "flex", alignItems: "center", gap: 8,
                    padding: "6px 12px", background: "var(--s2)", borderRadius: 8,
                    border: "1px solid var(--b1)", fontSize: 12 }}>
                    <span style={{ color: "var(--text)", fontWeight: 500 }}>{p.name}</span>
                    <span className={`db-stock-badge ${p.quantity === 0 ? "db-stock-zero" : "db-stock-low"}`}>
                      {p.quantity === 0 ? "Sem estoque" : `${p.quantity} un.`}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* ── Gráfico receita mensal ── */}
          <div className="db-card">
            <div className="db-card-header">
              <span className="db-card-title">Receita mensal (pedidos)</span>
              <span className="db-card-badge">Últimos 6 meses</span>
            </div>
            {loading ? (
              <div style={{ height: 170, display: "flex", alignItems: "flex-end", gap: 12 }}>
                {[60,90,50,110,75,95].map((h, i) => <SkBox key={i} h={h} />)}
              </div>
            ) : revenueByMonth.length === 0 ? (
              <div className="db-empty"><div className="db-empty-icon">📈</div><div className="db-empty-text">Nenhum pedido nos últimos 6 meses</div></div>
            ) : (
              <ResponsiveContainer width="100%" height={170}>
                <LineChart data={revenueByMonth} margin={{ top: 4, right: 4, bottom: 0, left: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="label" />
                  <YAxis tickFormatter={(v) => `R$${(v/1000).toFixed(0)}k`} width={48} />
                  <Tooltip content={<LineTooltip />} />
                  <Line type="monotone" dataKey="revenue" stroke="#00D4AA" strokeWidth={2}
                    dot={{ fill: "#00D4AA", r: 3, strokeWidth: 0 }} activeDot={{ r: 5, strokeWidth: 0 }} />
                </LineChart>
              </ResponsiveContainer>
            )}
          </div>

          {/* ── Produtos + Donut ── */}
          <div className="db-row db-row-2-1">
            <div className="db-card">
              <div className="db-card-header">
                <span className="db-card-title">Produtos mais vendidos</span>
                <span className="db-card-badge">Top {topProducts.length}</span>
              </div>
              {loading ? (
                <div style={{ display: "flex", gap: 10, alignItems: "flex-end", height: 110 }}>
                  {[60,90,45,75,30].map((h, i) => <SkBox key={i} h={h} />)}
                </div>
              ) : topProducts.length === 0 ? (
                <div className="db-empty"><div className="db-empty-icon">📦</div><div className="db-empty-text">Nenhum produto vendido ainda</div></div>
              ) : (
                <div className="db-bars">
                  {topProducts.map((p, i) => {
                    const pct = Math.round((Number(p.sold) / maxSold) * 100);
                    const colors = ["#7C6AF7","#00D4AA","#F7916A","#7C6AF7","#00D4AA"];
                    return (
                      <div key={i} className="db-bar-wrap">
                        <div className="db-bar"
                          style={{ height: `${pct}%`, background: colors[i % colors.length], opacity: 0.4 + 0.6 * (pct/100) }}
                          title={`${p.product}: ${p.sold} vendidos`} />
                        <div className="db-bar-label">{p.product}</div>
                      </div>
                    );
                  })}
                </div>
              )}
            </div>
            <div className="db-card">
              <div className="db-card-header">
                <span className="db-card-title">Por status</span>
                <span className="db-card-badge">Distribuição</span>
              </div>
              {loading ? (
                <div style={{ display: "flex", gap: 16, alignItems: "center" }}>
                  <div style={{ width: 80, height: 80, borderRadius: "50%", flexShrink: 0,
                    backgroundImage: "linear-gradient(90deg,#1A1A24 0%,#22223A 50%,#1A1A24 100%)",
                    backgroundSize: "200% 100%", animation: "shimmer 1.4s ease-in-out infinite" }} />
                  <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: 8 }}>
                    {[1,2,3,4].map(i => <SkBox key={i} h={13} />)}
                  </div>
                </div>
              ) : donutData.length === 0 ? (
                <div className="db-empty"><div className="db-empty-icon">📊</div><div className="db-empty-text">Sem pedidos no período</div></div>
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

          {/* ── Pedidos recentes + Top clientes ── */}
          <div className="db-row db-row-1-1">
            <div className="db-card" style={{ animationDelay: ".28s" }}>
              <div className="db-card-header">
                <span className="db-card-title">Pedidos recentes</span>
                <span className="db-card-badge">Últimos 8</span>
              </div>
              {loading ? (
                <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
                  {[1,2,3,4].map(i => (
                    <div key={i} style={{ display: "flex", gap: 10, alignItems: "center" }}>
                      <div style={{ width: 32, height: 32, borderRadius: 9, flexShrink: 0,
                        backgroundImage: "linear-gradient(90deg,#1A1A24 0%,#22223A 50%,#1A1A24 100%)",
                        backgroundSize: "200% 100%", animation: "shimmer 1.4s ease-in-out infinite" }} />
                      <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: 5 }}>
                        <SkBox h={13} /> <SkBox h={11} w="60%" />
                      </div>
                    </div>
                  ))}
                </div>
              ) : recentOrders.length === 0 ? (
                <div className="db-empty"><div className="db-empty-icon">🧾</div><div className="db-empty-text">Nenhum pedido ainda</div></div>
              ) : recentOrders.map((o, i) => {
                const sc = STATUS_STYLE[o.status] ?? STATUS_STYLE.pendente;
                const initials = o.client_name?.split(" ").map((w) => w[0]).slice(0,2).join("").toUpperCase() ?? "?";
                const color = AVATAR_COLORS[i % AVATAR_COLORS.length];
                return (
                  <div key={o.id} className="db-list-item">
                    <div className="db-avatar" style={{ background: color + "22", color }}>{initials}</div>
                    <div className="db-list-info">
                      <div className="db-list-name">{o.client_name}</div>
                      <div className="db-list-sub">#{o.id} · {new Date(o.created_at).toLocaleDateString("pt-BR")}</div>
                    </div>
                    <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end", gap: 4 }}>
                      <div className="db-list-val">{formatCurrency(o.total)}</div>
                      <span className="db-status" style={{ background: sc.bg, color: sc.text }}>{o.status}</span>
                    </div>
                  </div>
                );
              })}
            </div>

            <div className="db-card" style={{ animationDelay: ".32s" }}>
              <div className="db-card-header">
                <span className="db-card-title">Top clientes</span>
                <span className="db-card-badge">{topClients.length} clientes</span>
              </div>
              {loading ? (
                <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
                  {[1,2,3,4].map(i => (
                    <div key={i} style={{ display: "flex", gap: 10, alignItems: "center" }}>
                      <div style={{ width: 32, height: 32, borderRadius: 9, flexShrink: 0,
                        backgroundImage: "linear-gradient(90deg,#1A1A24 0%,#22223A 50%,#1A1A24 100%)",
                        backgroundSize: "200% 100%", animation: "shimmer 1.4s ease-in-out infinite" }} />
                      <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: 5 }}>
                        <SkBox h={13} /> <SkBox h={11} w="60%" />
                      </div>
                    </div>
                  ))}
                </div>
              ) : topClients.length === 0 ? (
                <div className="db-empty"><div className="db-empty-icon">👥</div><div className="db-empty-text">Nenhum cliente com pedidos</div></div>
              ) : topClients.map((c, i) => {
                const initials = c.client.split(" ").map((w) => w[0]).slice(0,2).join("").toUpperCase();
                const color = AVATAR_COLORS[i % AVATAR_COLORS.length];
                return (
                  <div key={i} className="db-list-item">
                    <div className="db-avatar" style={{ background: color + "22", color }}>{initials}</div>
                    <div className="db-list-info">
                      <div className="db-list-name">{c.client}</div>
                      <div className="db-list-sub">{c.orders} {Number(c.orders) === 1 ? "pedido" : "pedidos"}</div>
                    </div>
                    <div className="db-list-val">{c.orders}</div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Dashboard;