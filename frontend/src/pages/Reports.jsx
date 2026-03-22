import React, { useState } from "react";
import PageShell from "../components/PageShell";
import { useFetch } from "../hooks";
import { formatCurrency } from "../utils/formatCurrency";

const ICON_PATH = "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8l-6-6zm-1 1.5L18.5 9H13V3.5zM8 13h8v1.5H8V13zm0 3h8v1.5H8V16zm0-6h3v1.5H8V10z";

const today     = () => new Date().toISOString().split("T")[0];
const monthStart= () => new Date(new Date().getFullYear(), new Date().getMonth(), 1).toISOString().split("T")[0];
const fmtDate   = (d) => d ? new Date(d).toLocaleDateString("pt-BR") : "—";

// ── Carrega libs dinamicamente ────────────────────────────────────────────────
const loadXLSX = () => {
  if (window.XLSX) return Promise.resolve(window.XLSX);
  return new Promise((res, rej) => {
    const s = document.createElement("script");
    s.src = "https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js";
    s.onload  = () => res(window.XLSX);
    s.onerror = rej;
    document.head.appendChild(s);
  });
};

const loadJsPDF = () => {
  if (window.jspdf) return Promise.resolve(window.jspdf.jsPDF);
  return new Promise((res, rej) => {
    const s1 = document.createElement("script");
    s1.src = "https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js";
    s1.onload = () => {
      const s2 = document.createElement("script");
      s2.src = "https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.2/jspdf.plugin.autotable.min.js";
      s2.onload  = () => res(window.jspdf.jsPDF);
      s2.onerror = rej;
      document.head.appendChild(s2);
    };
    s1.onerror = rej;
    document.head.appendChild(s1);
  });
};

// ── Exportadores ──────────────────────────────────────────────────────────────
const exportXLSX = async (sheets, filename) => {
  const XLSX = await loadXLSX();
  const wb   = XLSX.utils.book_new();
  for (const { name, headers, rows } of sheets) {
    const data = [headers, ...rows];
    const ws   = XLSX.utils.aoa_to_sheet(data);
    // Largura automática
    const colWidths = headers.map((h, i) =>
      Math.max(h.length, ...rows.map((r) => String(r[i] ?? "").length), 10) + 2
    );
    ws["!cols"] = colWidths.map((w) => ({ wch: w }));
    XLSX.utils.book_append_sheet(wb, ws, name);
  }
  XLSX.writeFile(wb, filename);
};

const exportPDF = async (title, headers, rows, filename, summary = null) => {
  const JsPDF = await loadJsPDF();
  const doc   = new JsPDF({ orientation: "landscape", unit: "mm", format: "a4" });

  // Cabeçalho
  doc.setFontSize(16);
  doc.setFont("helvetica", "bold");
  doc.text(title, 14, 16);

  doc.setFontSize(9);
  doc.setFont("helvetica", "normal");
  doc.setTextColor(120);
  doc.text(`Gerado em ${new Date().toLocaleString("pt-BR")}`, 14, 22);
  doc.setTextColor(0);

  // Sumário opcional
  let startY = 28;
  if (summary) {
    doc.setFontSize(10);
    let x = 14;
    for (const [label, value] of Object.entries(summary)) {
      doc.setFont("helvetica", "bold");
      doc.text(`${label}: `, x, startY);
      doc.setFont("helvetica", "normal");
      doc.text(String(value), x + doc.getTextWidth(`${label}: `), startY);
      x += doc.getTextWidth(`${label}: ${value}`) + 10;
      if (x > 250) { x = 14; startY += 5; }
    }
    startY += 8;
  }

  doc.autoTable({
    head: [headers],
    body: rows,
    startY,
    theme: "grid",
    headStyles: { fillColor: [28, 28, 42], textColor: 255, fontStyle: "bold", fontSize: 9 },
    bodyStyles: { fontSize: 8, textColor: 40 },
    alternateRowStyles: { fillColor: [245, 245, 250] },
    margin: { left: 14, right: 14 },
  });

  doc.save(filename);
};

// ── Card de relatório ─────────────────────────────────────────────────────────
const ReportCard = ({ title, description, icon, children, onExportXLSX, onExportPDF, loading }) => (
  <div style={{ background: "var(--color-surface)", border: "1px solid var(--color-border)",
    borderRadius: 14, overflow: "hidden" }}>
    <div style={{ padding: "18px 22px", borderBottom: "1px solid var(--color-border)",
      display: "flex", alignItems: "center", justifyContent: "space-between", flexWrap: "wrap", gap: 12 }}>
      <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
        <div style={{ width: 34, height: 34, borderRadius: 9, background: "rgba(124,106,247,0.1)",
          border: "1px solid rgba(124,106,247,0.2)", display: "flex", alignItems: "center",
          justifyContent: "center", color: "var(--color-primary)", flexShrink: 0 }}>
          {icon}
        </div>
        <div>
          <div style={{ fontSize: 13, fontWeight: 600, color: "var(--color-text)" }}>{title}</div>
          <div style={{ fontSize: 11, color: "var(--color-textMuted)", marginTop: 2 }}>{description}</div>
        </div>
      </div>
      <div style={{ display: "flex", gap: 8 }}>
        <button onClick={onExportXLSX} disabled={loading} style={btnXLSX}>
          {loading ? "..." : "⬇ Excel"}
        </button>
        <button onClick={onExportPDF} disabled={loading} style={btnPDF}>
          {loading ? "..." : "⬇ PDF"}
        </button>
      </div>
    </div>
    {children && (
      <div style={{ padding: "14px 22px" }}>{children}</div>
    )}
  </div>
);

// ── Relatório: Pedidos ────────────────────────────────────────────────────────
const OrdersReport = () => {
  const [filters, setFilters] = useState({ from: monthStart(), to: today(), status: "" });
  const [applied, setApplied] = useState({ from: monthStart(), to: today(), status: "" });
  const [exporting, setExporting] = useState(false);

  const buildUrl = () => {
    const p = new URLSearchParams();
    if (applied.status) p.set("status", applied.status);
    return `/orders?${p.toString()}`;
  };

  const { data: rawOrders, loading } = useFetch(buildUrl(), true, 0);

  const orders = (rawOrders || []).filter((o) => {
    const d = new Date(o.created_at);
    return d >= new Date(applied.from) && d <= new Date(applied.to + "T23:59:59");
  });

  const total = orders.reduce((s, o) => s + Number(o.total ?? o.total_amount ?? 0), 0);

  const headers = ["ID", "Cliente", "Total (R$)", "Status", "Data"];
  const rows    = orders.map((o) => [
    `#${o.order_id ?? o.id}`,
    o.client_name ?? o.client ?? "—",
    formatCurrency(o.total ?? o.total_amount ?? 0),
    o.status,
    fmtDate(o.created_at),
  ]);

  const doXLSX = async () => {
    setExporting(true);
    try {
      await exportXLSX([{ name: "Pedidos", headers, rows }], `pedidos_${applied.from}_${applied.to}.xlsx`);
    } finally { setExporting(false); }
  };

  const doPDF = async () => {
    setExporting(true);
    try {
      await exportPDF(
        `Relatório de Pedidos — ${fmtDate(applied.from)} a ${fmtDate(applied.to)}`,
        headers, rows,
        `pedidos_${applied.from}_${applied.to}.pdf`,
        { "Total de pedidos": orders.length, "Valor total": formatCurrency(total) }
      );
    } finally { setExporting(false); }
  };

  return (
    <ReportCard title="Pedidos" description="Lista completa com cliente, total e status"
      icon={ordersIcon} onExportXLSX={doXLSX} onExportPDF={doPDF} loading={loading || exporting}>
      <div style={filterRow}>
        <input type="date" style={inputSm} value={filters.from}
          onChange={(e) => setFilters((p) => ({ ...p, from: e.target.value }))} />
        <span style={filterLabel}>até</span>
        <input type="date" style={inputSm} value={filters.to}
          onChange={(e) => setFilters((p) => ({ ...p, to: e.target.value }))} />
        <select style={inputSm} value={filters.status}
          onChange={(e) => setFilters((p) => ({ ...p, status: e.target.value }))}>
          <option value="">Todos os status</option>
          {["pendente","pago","enviado","entregue","concluído","cancelado"].map((s) => (
            <option key={s} value={s}>{s}</option>
          ))}
        </select>
        <button style={btnApply} onClick={() => setApplied(filters)}>Aplicar</button>
        <span style={countBadge}>{loading ? "—" : `${orders.length} pedidos · ${formatCurrency(total)}`}</span>
      </div>
    </ReportCard>
  );
};

// ── Relatório: Clientes ───────────────────────────────────────────────────────
const ClientsReport = () => {
  const [exporting, setExporting] = useState(false);
  const { data: clients, loading } = useFetch("/clients", true, 5 * 60 * 1000);

  const headers = ["ID", "Nome", "Email", "Telefone", "Endereço", "Cadastro"];
  const rows    = (clients || []).map((c) => [
    c.id, c.name, c.email ?? "—", c.phone ?? "—", c.address ?? "—", fmtDate(c.created_at),
  ]);

  const doXLSX = async () => {
    setExporting(true);
    try {
      await exportXLSX([{ name: "Clientes", headers, rows }], "clientes.xlsx");
    } finally { setExporting(false); }
  };

  const doPDF = async () => {
    setExporting(true);
    try {
      await exportPDF(
        "Relatório de Clientes",
        headers, rows,
        "clientes.pdf",
        { "Total de clientes": (clients || []).length }
      );
    } finally { setExporting(false); }
  };

  return (
    <ReportCard title="Clientes" description="Cadastro completo de clientes"
      icon={clientsIcon} onExportXLSX={doXLSX} onExportPDF={doPDF} loading={loading || exporting}>
      <div style={filterRow}>
        <span style={countBadge}>{loading ? "—" : `${(clients || []).length} clientes`}</span>
      </div>
    </ReportCard>
  );
};

// ── Relatório: Produtos ───────────────────────────────────────────────────────
const ProductsReport = () => {
  const [exporting, setExporting] = useState(false);
  const { data: products, loading } = useFetch("/products", true, 5 * 60 * 1000);

  const headers = ["ID", "Nome", "Descrição", "Preço (R$)", "Estoque", "Status estoque"];
  const rows    = (products || []).map((p) => {
    const qty = Number(p.stock_quantity ?? 0);
    return [
      p.id, p.name, p.description ?? "—",
      formatCurrency(p.price),
      qty,
      qty === 0 ? "Sem estoque" : qty <= 5 ? "Estoque baixo" : "Normal",
    ];
  });

  const doXLSX = async () => {
    setExporting(true);
    try {
      await exportXLSX([{ name: "Produtos", headers, rows }], "produtos.xlsx");
    } finally { setExporting(false); }
  };

  const doPDF = async () => {
    setExporting(true);
    try {
      await exportPDF(
        "Catálogo de Produtos",
        headers, rows,
        "produtos.pdf",
        { "Total de produtos": (products || []).length }
      );
    } finally { setExporting(false); }
  };

  return (
    <ReportCard title="Produtos" description="Catálogo com preço e estoque"
      icon={productsIcon} onExportXLSX={doXLSX} onExportPDF={doPDF} loading={loading || exporting}>
      <div style={filterRow}>
        <span style={countBadge}>{loading ? "—" : `${(products || []).length} produtos`}</span>
      </div>
    </ReportCard>
  );
};

// ── Relatório: Financeiro ─────────────────────────────────────────────────────
const FinancialReport = () => {
  const [filters, setFilters] = useState({ from: monthStart(), to: today(), type: "" });
  const [applied, setApplied] = useState({ from: monthStart(), to: today(), type: "" });
  const [exporting, setExporting] = useState(false);

  const buildUrl = () => {
    const p = new URLSearchParams({ from: applied.from, to: applied.to });
    if (applied.type) p.set("type", applied.type);
    return `/financial?${p.toString()}`;
  };

  const { data: transactions, loading } = useFetch(buildUrl(), true, 0);
  const txs = transactions || [];

  const receita = txs.filter((t) => t.type === "receita" && t.status !== "cancelado")
    .reduce((s, t) => s + Number(t.amount), 0);
  const despesa = txs.filter((t) => t.type === "despesa" && t.status !== "cancelado")
    .reduce((s, t) => s + Number(t.amount), 0);

  const headers = ["Tipo","Descrição","Categoria","Vencimento","Pago em","Valor (R$)","Status"];
  const rows    = txs.map((t) => [
    t.type === "receita" ? "Receita" : "Despesa",
    t.description,
    t.category_name ?? "—",
    fmtDate(t.due_date),
    fmtDate(t.paid_date),
    formatCurrency(t.amount),
    t.status,
  ]);

  const doXLSX = async () => {
    setExporting(true);
    try {
      await exportXLSX([{ name: "Financeiro", headers, rows }],
        `financeiro_${applied.from}_${applied.to}.xlsx`);
    } finally { setExporting(false); }
  };

  const doPDF = async () => {
    setExporting(true);
    try {
      await exportPDF(
        `Relatório Financeiro — ${fmtDate(applied.from)} a ${fmtDate(applied.to)}`,
        headers, rows,
        `financeiro_${applied.from}_${applied.to}.pdf`,
        {
          "Receitas": formatCurrency(receita),
          "Despesas": formatCurrency(despesa),
          "Saldo":    formatCurrency(receita - despesa),
        }
      );
    } finally { setExporting(false); }
  };

  return (
    <ReportCard title="Financeiro" description="Lançamentos com totais por período"
      icon={financialIcon} onExportXLSX={doXLSX} onExportPDF={doPDF} loading={loading || exporting}>
      <div style={filterRow}>
        <input type="date" style={inputSm} value={filters.from}
          onChange={(e) => setFilters((p) => ({ ...p, from: e.target.value }))} />
        <span style={filterLabel}>até</span>
        <input type="date" style={inputSm} value={filters.to}
          onChange={(e) => setFilters((p) => ({ ...p, to: e.target.value }))} />
        <select style={inputSm} value={filters.type}
          onChange={(e) => setFilters((p) => ({ ...p, type: e.target.value }))}>
          <option value="">Receitas e despesas</option>
          <option value="receita">Só receitas</option>
          <option value="despesa">Só despesas</option>
        </select>
        <button style={btnApply} onClick={() => setApplied(filters)}>Aplicar</button>
        <span style={countBadge}>
          {loading ? "—" : `${txs.length} lançamentos · Saldo: ${formatCurrency(receita - despesa)}`}
        </span>
      </div>
    </ReportCard>
  );
};

// ── Relatório: Fluxo de Caixa ─────────────────────────────────────────────────
const CashFlowReport = () => {
  const [filters, setFilters] = useState({ from: `${new Date().getFullYear()}-01-01`, to: today() });
  const [applied, setApplied] = useState({ from: `${new Date().getFullYear()}-01-01`, to: today() });
  const [exporting, setExporting] = useState(false);

  const { data: cf, loading } = useFetch(
    `/financial/cash-flow?from=${applied.from}&to=${applied.to}`, true, 0
  );

  const byMonth = cf?.byMonth ?? [];

  // Agrupa por mês
  const monthMap = {};
  for (const row of byMonth) {
    if (!monthMap[row.label]) monthMap[row.label] = { label: row.label, receita: 0, despesa: 0 };
    monthMap[row.label][row.type] = Number(row.total);
  }
  const monthRows = Object.values(monthMap).map((m) => ({
    ...m, saldo: m.receita - m.despesa,
  }));

  const totalReceita = monthRows.reduce((s, m) => s + m.receita, 0);
  const totalDespesa = monthRows.reduce((s, m) => s + m.despesa, 0);

  const headers = ["Mês", "Receitas (R$)", "Despesas (R$)", "Saldo (R$)"];
  const rows    = [
    ...monthRows.map((m) => [
      m.label,
      formatCurrency(m.receita),
      formatCurrency(m.despesa),
      formatCurrency(m.saldo),
    ]),
    ["TOTAL", formatCurrency(totalReceita), formatCurrency(totalDespesa), formatCurrency(totalReceita - totalDespesa)],
  ];

  const doXLSX = async () => {
    setExporting(true);
    try {
      await exportXLSX([{ name: "Fluxo de Caixa", headers, rows }],
        `fluxo_caixa_${applied.from}_${applied.to}.xlsx`);
    } finally { setExporting(false); }
  };

  const doPDF = async () => {
    setExporting(true);
    try {
      await exportPDF(
        `Fluxo de Caixa — ${fmtDate(applied.from)} a ${fmtDate(applied.to)}`,
        headers, rows,
        `fluxo_caixa_${applied.from}_${applied.to}.pdf`,
        {
          "Receitas totais": formatCurrency(totalReceita),
          "Despesas totais": formatCurrency(totalDespesa),
          "Saldo":           formatCurrency(totalReceita - totalDespesa),
        }
      );
    } finally { setExporting(false); }
  };

  return (
    <ReportCard title="Fluxo de Caixa" description="Receitas x despesas consolidadas por mês"
      icon={cashFlowIcon} onExportXLSX={doXLSX} onExportPDF={doPDF} loading={loading || exporting}>
      <div style={filterRow}>
        <input type="date" style={inputSm} value={filters.from}
          onChange={(e) => setFilters((p) => ({ ...p, from: e.target.value }))} />
        <span style={filterLabel}>até</span>
        <input type="date" style={inputSm} value={filters.to}
          onChange={(e) => setFilters((p) => ({ ...p, to: e.target.value }))} />
        <button style={btnApply} onClick={() => setApplied(filters)}>Aplicar</button>
        <span style={countBadge}>
          {loading ? "—" : `${monthRows.length} meses · Saldo: ${formatCurrency(totalReceita - totalDespesa)}`}
        </span>
      </div>
    </ReportCard>
  );
};

// ── Ícones SVG ────────────────────────────────────────────────────────────────
const SvgIcon = ({ d }) => (
  <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
    <path d={d} stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
  </svg>
);
const ordersIcon    = <SvgIcon d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 5a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2M9 5a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2" />;
const clientsIcon   = <SvgIcon d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />;
const productsIcon  = <SvgIcon d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />;
const financialIcon = <SvgIcon d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z" />;
const cashFlowIcon  = <SvgIcon d="M3 3h18v18H3zM3 9h18M3 15h18M9 3v18M15 3v18" />;

// ── Estilos ───────────────────────────────────────────────────────────────────
const btnXLSX = {
  padding: "7px 14px", background: "rgba(0,180,80,0.1)", color: "#00B450",
  border: "1px solid rgba(0,180,80,0.25)", borderRadius: 8, fontFamily: "inherit",
  fontSize: 12, fontWeight: 600, cursor: "pointer",
};
const btnPDF = {
  padding: "7px 14px", background: "rgba(220,50,50,0.1)", color: "#DC3232",
  border: "1px solid rgba(220,50,50,0.25)", borderRadius: 8, fontFamily: "inherit",
  fontSize: 12, fontWeight: 600, cursor: "pointer",
};
const btnApply = {
  padding: "6px 14px", background: "var(--color-primary)", color: "#fff",
  border: "none", borderRadius: 7, fontFamily: "inherit", fontSize: 12,
  fontWeight: 600, cursor: "pointer",
};
const inputSm = {
  padding: "6px 10px", background: "var(--color-surface2)",
  border: "1px solid var(--color-border2)", borderRadius: 7,
  color: "var(--color-text)", fontFamily: "inherit", fontSize: 12, outline: "none",
  flex: "1 1 120px", minWidth: 0,
};
const filterRow   = { display: "flex", alignItems: "center", gap: 6, flexWrap: "wrap", width: "100%" };
const filterLabel = { fontSize: 12, color: "var(--color-textMuted)" };
const countBadge  = {
  fontSize: 11, fontWeight: 600, padding: "3px 10px",
  background: "rgba(124,106,247,0.1)", color: "var(--color-primary)",
  borderRadius: 99, fontFamily: "var(--font-mono)",
};

// ── Página ────────────────────────────────────────────────────────────────────
const Reports = () => (
  <div className="main-content">
    <PageShell
      title="Relatórios"
      icon={ICON_PATH}
      description="Exporte dados do sistema em PDF ou Excel"
    />
    <div className="page-body">
      <OrdersReport />
      <ClientsReport />
      <ProductsReport />
      <FinancialReport />
      <CashFlowReport />
    </div>
  </div>
);

export default Reports;