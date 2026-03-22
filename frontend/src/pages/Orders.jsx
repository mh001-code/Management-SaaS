import React, { useRef, useState, useMemo, useCallback } from "react";
import { useFetch, useSearch, usePagination } from "../hooks";
import { API_ENDPOINTS } from "../constants";
import api from "../services/api";
import errorService from "../services/errorService";
import notificationService from "../services/notificationService";
import { formatCurrency } from "../utils/formatCurrency";
import DataTable from "../components/DataTable";
import OrderForm from "../components/OrderForm";
import PageShell from "../components/PageShell";
import Pagination from "../components/Pagination";

const STATUS_META = {
  pendente:    { bg: "rgba(247,145,106,0.12)", text: "#F7916A", dot: "#F7916A", label: "Pendente"   },
  pago:        { bg: "rgba(0,212,170,0.12)",   text: "#00D4AA", dot: "#00D4AA", label: "Pago"       },
  enviado:     { bg: "rgba(124,106,247,0.12)", text: "#7C6AF7", dot: "#7C6AF7", label: "Enviado"    },
  entregue:    { bg: "rgba(0,212,170,0.12)",   text: "#00D4AA", dot: "#00D4AA", label: "Entregue"   },
  "concluído": { bg: "rgba(0,212,170,0.12)",   text: "#00D4AA", dot: "#00D4AA", label: "Concluído"  },
  cancelado:   { bg: "rgba(247,100,100,0.12)", text: "#F76464", dot: "#F76464", label: "Cancelado"  },
  estornado:   { bg: "rgba(122,122,154,0.12)", text: "#7A7A9A", dot: "#7A7A9A", label: "Estornado"  },
  recusado:    { bg: "rgba(247,100,100,0.12)", text: "#F76464", dot: "#F76464", label: "Recusado"   },
};

const StatusBadge = ({ status }) => {
  const m = STATUS_META[status] ?? STATUS_META.pendente;
  return (
    <span style={{
      display: "inline-flex", alignItems: "center", gap: 5,
      padding: "3px 10px", borderRadius: 99,
      background: m.bg, color: m.text,
      fontSize: 11, fontWeight: 600, whiteSpace: "nowrap",
    }}>
      <span style={{ width: 5, height: 5, borderRadius: "50%", background: m.dot, flexShrink: 0 }} />
      {m.label}
    </span>
  );
};

const ICON_PATH = "M4 5h12M4 10h12M4 15h8";

const STATUS_HISTORY = {
  pendente:    ["pendente"],
  pago:        ["pendente", "pago"],
  enviado:     ["pendente", "pago", "enviado"],
  entregue:    ["pendente", "pago", "enviado", "entregue"],
  "concluído": ["pendente", "pago", "enviado", "entregue", "concluído"],
  cancelado:   ["pendente", "cancelado"],
  estornado:   ["pendente", "pago", "estornado"],
  recusado:    ["pendente", "recusado"],
};

const OrderDrawer = ({ order, onClose }) => {
  if (!order) return null;
  const history  = STATUS_HISTORY[order.status] ?? [order.status];
  const isFinal  = ["cancelado", "estornado", "recusado"].includes(order.status);
  const allSteps = ["pendente", "pago", "enviado", "entregue", "concluído"];
  const steps    = isFinal ? history : allSteps;

  return (
    <>
      <div style={{ position: "fixed", inset: 0, zIndex: 900, background: "rgba(0,0,0,0.45)" }} onClick={onClose} />
      <div style={{
        position: "fixed", top: 0, right: 0, bottom: 0, zIndex: 901,
        width: 380, background: "var(--color-surface)",
        borderLeft: "1px solid var(--color-border)",
        boxShadow: "-16px 0 48px rgba(0,0,0,0.5)",
        display: "flex", flexDirection: "column",
        animation: "drawerIn 240ms cubic-bezier(0.22,1,0.36,1)",
      }}>
        <style>{`@keyframes drawerIn { from { transform: translateX(100%); } to { transform: translateX(0); } }`}</style>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center",
          padding: "20px 24px", borderBottom: "1px solid var(--color-border)", flexShrink: 0 }}>
          <div>
            <div style={{ fontSize: 15, fontWeight: 700, color: "var(--color-text)", marginBottom: 4 }}>Pedido #{order.id}</div>
            <StatusBadge status={order.status} />
          </div>
          <button onClick={onClose} style={{ background: "none", border: "none", color: "var(--color-textMuted)", cursor: "pointer", fontSize: 22, lineHeight: 1, padding: 4 }}>×</button>
        </div>
        <div style={{ flex: 1, overflowY: "auto", padding: 24 }}>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10, marginBottom: 24 }}>
            {[
              { label: "Cliente", value: order.client },
              { label: "Total",   value: formatCurrency(order.total_amount) },
              { label: "Data",    value: order.created_at ? new Date(order.created_at).toLocaleDateString("pt-BR") : "—" },
              { label: "Itens",   value: `${order.items?.length ?? "—"} produto(s)` },
            ].map(({ label, value }) => (
              <div key={label} style={{ background: "rgba(0,0,0,0.02)", borderRadius: 9,
                padding: "10px 14px", border: "1px solid var(--color-border)" }}>
                <div style={{ fontSize: 10, color: "var(--color-textMuted)", fontWeight: 600,
                  textTransform: "uppercase", letterSpacing: "0.8px", marginBottom: 4 }}>{label}</div>
                <div style={{ fontSize: 13, color: "var(--color-text)", fontWeight: 500 }}>{value}</div>
              </div>
            ))}
          </div>

          <div>
            <div style={{ fontSize: 11, fontWeight: 600, color: "var(--color-textMuted)",
              textTransform: "uppercase", letterSpacing: "0.8px", marginBottom: 14 }}>Histórico de status</div>
            <div style={{ position: "relative", paddingLeft: 20 }}>
              <div style={{ position: "absolute", left: 7, top: 8, width: 1,
                height: "calc(100% - 16px)", background: "var(--color-border2)" }} />
              {steps.map((step, i) => {
                const isDone    = history.includes(step);
                const isCurrent = step === order.status;
                const m         = STATUS_META[step] ?? STATUS_META.pendente;
                return (
                  <div key={step} style={{ display: "flex", alignItems: "center", gap: 12,
                    marginBottom: i < steps.length - 1 ? 14 : 0, opacity: isDone ? 1 : 0.3 }}>
                    <div style={{ width: 14, height: 14, borderRadius: "50%", flexShrink: 0,
                      background: isDone ? m.dot : "var(--color-border2)",
                      border: isCurrent ? `2px solid ${m.dot}` : "2px solid transparent",
                      boxShadow: isCurrent ? `0 0 8px ${m.dot}66` : "none",
                      position: "relative", zIndex: 1, marginLeft: -20,
                      display: "flex", alignItems: "center", justifyContent: "center" }}>
                      {isCurrent && <div style={{ width: 6, height: 6, borderRadius: "50%", background: m.dot }} />}
                    </div>
                    <span style={{ fontSize: 13, fontWeight: isCurrent ? 600 : 400,
                      color: isCurrent ? m.text : isDone ? "#F0F0F8" : "#7A7A9A" }}>
                      {m.label ?? step}
                    </span>
                    {isCurrent && (
                      <span style={{ fontSize: 10, padding: "2px 7px", borderRadius: 99,
                        background: m.bg, color: m.text, fontWeight: 600 }}>atual</span>
                    )}
                  </div>
                );
              })}
            </div>
          </div>

          {order.items?.length > 0 && (
            <div style={{ marginTop: 24 }}>
              <div style={{ fontSize: 11, fontWeight: 600, color: "var(--color-textMuted)",
                textTransform: "uppercase", letterSpacing: "0.8px", marginBottom: 10 }}>Itens</div>
              {order.items.map((item, i) => (
                <div key={i} style={{ display: "flex", justifyContent: "space-between",
                  padding: "8px 12px", borderRadius: 8, marginBottom: 6,
                  background: "rgba(0,0,0,0.02)", border: "1px solid var(--color-border)" }}>
                  <span style={{ fontSize: 13, color: "var(--color-text)" }}>
                    {item.product_name ?? item.name ?? `Produto ${item.product_id}`}
                  </span>
                  <span style={{ fontSize: 12, color: "var(--color-textMuted)" }}>{item.quantity} un.</span>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </>
  );
};

const Orders = () => {
  const formRef = useRef(null);
  const [editingOrder, setEditingOrder] = useState(null);
  const [statusFilter, setStatusFilter] = useState("todos");
  const [drawerOrder,  setDrawerOrder]  = useState(null);
  const [dateFrom,     setDateFrom]     = useState("");
  const [dateTo,       setDateTo]       = useState("");

  const { data: rawOrders, loading, error, refetch } = useFetch(API_ENDPOINTS.ORDERS, true, 5 * 60 * 1000);

  const orders = useMemo(() =>
    (rawOrders || []).map((o) => ({
      ...o,
      id:           o.order_id ?? o.id,
      client:       o.client_name ?? o.client,
      total_amount: o.total ?? o.total_amount,
    })), [rawOrders]);

  const { search, setSearch, filtered: searchFiltered } = useSearch(orders, ["client", "id"]);

  const filtered = useMemo(() => searchFiltered.filter((o) => {
    const matchStatus = statusFilter === "todos" || o.status === statusFilter;
    let   matchDate   = true;
    if (dateFrom || dateTo) {
      const d = new Date(o.created_at);
      if (dateFrom && d < new Date(dateFrom)) matchDate = false;
      if (dateTo   && d > new Date(dateTo + "T23:59:59")) matchDate = false;
    }
    return matchStatus && matchDate;
  }), [searchFiltered, statusFilter, dateFrom, dateTo]);

  const statuses = useMemo(() => ["todos", ...new Set(orders.map((o) => o.status).filter(Boolean))], [orders]);

  const kpis = useMemo(() => ({
    total:     filtered.length,
    revenue:   filtered.filter((o) => ["pago","entregue","concluído"].includes(o.status))
                       .reduce((s, o) => s + Number(o.total_amount || 0), 0),
    pending:   filtered.filter((o) => o.status === "pendente").length,
    cancelled: filtered.filter((o) => ["cancelado","estornado"].includes(o.status)).length,
  }), [filtered]);

  const { paginatedItems, currentPage, goToPage, totalPages } = usePagination(filtered, 10);

  const handleEdit   = useCallback((order) => { setEditingOrder(order); formRef.current?.scrollIntoView({ behavior: "smooth", block: "start" }); }, []);
  const handleDelete = useCallback(async (id) => {
    try { await api.delete(`${API_ENDPOINTS.ORDERS}/${id}`); notificationService.success("Pedido deletado!"); refetch(); }
    catch (err) { notificationService.error(errorService.handle(err, "deletar pedido")); }
  }, [refetch]);

  const hasFilters = statusFilter !== "todos" || dateFrom || dateTo || search;

  return (
    <div className="main-content">
      <PageShell
        title="Pedidos" count={loading ? null : filtered.length} icon={ICON_PATH}
        description="Gerencie pedidos e acompanhe o status de cada venda"
        actions={
          <>
            <input className="input" placeholder="Buscar cliente, ID..." value={search}
              onChange={(e) => { setSearch(e.target.value); goToPage(1); }} style={{ width: 185 }} />
            <select className="input" value={statusFilter}
              onChange={(e) => { setStatusFilter(e.target.value); goToPage(1); }} style={{ width: 140 }}>
              {statuses.map((s) => (
                <option key={s} value={s}>{s === "todos" ? "Todos status" : (STATUS_META[s]?.label ?? s)}</option>
              ))}
            </select>
            <input className="input" type="date" value={dateFrom} title="Data inicial"
              onChange={(e) => { setDateFrom(e.target.value); goToPage(1); }} style={{ width: 140 }} />
            <input className="input" type="date" value={dateTo} title="Data final"
              onChange={(e) => { setDateTo(e.target.value); goToPage(1); }} style={{ width: 140 }} />
            {hasFilters && (
              <button onClick={() => { setStatusFilter("todos"); setDateFrom(""); setDateTo(""); setSearch(""); }}
                style={{ padding: "7px 12px", borderRadius: 8, fontSize: 12, fontWeight: 600,
                  border: "1px solid rgba(247,100,100,0.25)", background: "rgba(247,100,100,0.08)",
                  color: "#F76464", cursor: "pointer" }}>✕ Limpar</button>
            )}
          </>
        }
      />

      <div className="page-body">
        {error && <div className="alert alert-danger">{error}</div>}

        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(140px, 1fr))", gap: 12, marginBottom: 20 }}>
          {[
            { label: "Total filtrado", value: kpis.total,                   color: "#7C6AF7", mono: false },
            { label: "Receita",        value: formatCurrency(kpis.revenue), color: "#00D4AA", mono: true  },
            { label: "Pendentes",      value: kpis.pending,                 color: "#F7916A", mono: false },
            { label: "Cancelados",     value: kpis.cancelled,               color: "#F76464", mono: false },
          ].map(({ label, value, color, mono }) => (
            <div key={label} style={{ background: "var(--color-surface)", border: "1px solid var(--color-border)",
              borderRadius: 12, padding: "14px 18px" }}>
              <div style={{ fontSize: 10, fontWeight: 600, color: "var(--color-textMuted)",
                textTransform: "uppercase", letterSpacing: "0.8px", marginBottom: 6 }}>{label}</div>
              <div style={{ fontSize: mono ? 18 : 24, fontWeight: 700, color,
                fontFamily: mono ? "var(--font-mono)" : "inherit" }}>{value}</div>
            </div>
          ))}
        </div>

        <div ref={formRef}>
          <div className="chart-card">
            <div className="chart-header">
              <div className="chart-title">{editingOrder ? "✎ Editar pedido" : "+ Novo pedido"}</div>
              {editingOrder && (
                <button onClick={() => setEditingOrder(null)}
                  style={{ background: "none", border: "none", color: "var(--color-textMuted)", cursor: "pointer", fontSize: 13 }}>
                  Cancelar edição
                </button>
              )}
            </div>
            <OrderForm onOrderCreated={refetch} editingOrder={editingOrder} onCancel={() => setEditingOrder(null)} />
          </div>
        </div>

        <div className="chart-card">
          <DataTable
            rows={paginatedItems}
            columns={[
              { key: "id", label: "ID", render: (v) => <span style={{ fontFamily: "var(--font-mono)", color: "var(--color-textMuted)" }}>#{v}</span> },
              { key: "client",       label: "Cliente" },
              { key: "total_amount", label: "Total",  render: (v) => <span style={{ fontFamily: "var(--font-mono)", fontWeight: 600 }}>{formatCurrency(v)}</span> },
              { key: "status",       label: "Status", render: (v) => <StatusBadge status={v} /> },
              { key: "created_at",   label: "Data",   render: (v) => v ? new Date(v).toLocaleDateString("pt-BR") : "—" },
              { key: "_hist", label: "", render: (_, row) => (
                <button onClick={(e) => { e.stopPropagation(); setDrawerOrder(row); }}
                  style={{ padding: "3px 10px", borderRadius: 6, border: "1px solid rgba(124,106,247,0.2)",
                    background: "rgba(124,106,247,0.06)", color: "#7C6AF7", fontSize: 11,
                    fontWeight: 600, cursor: "pointer", whiteSpace: "nowrap" }}>
                  Histórico
                </button>
              )},
            ]}
            onEdit={handleEdit} onDelete={handleDelete}
            isLoading={loading} emptyMessage="Nenhum pedido encontrado" emptyIcon="orders"
          />
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} />
        </div>
      </div>

      <OrderDrawer order={drawerOrder} onClose={() => setDrawerOrder(null)} />
    </div>
  );
};

export default Orders;