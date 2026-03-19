import React, { useState, useMemo, useCallback } from "react";
import { useFetch, usePagination } from "../hooks";
import api from "../services/api";
import errorService from "../services/errorService";
import notificationService from "../services/notificationService";
import { formatCurrency } from "../utils/formatCurrency";
import DataTable from "../components/DataTable";
import PageShell from "../components/PageShell";
import Pagination from "../components/Pagination";

// ── Constantes ─────────────────────────────────────────────────────────────────

const ICON_PATH = "M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 5a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2M9 5a2 2 0 0 0 2-2h2a2 2 0 0 0 2 2m-6 9l2 2 4-4";

const STATUS_META = {
  pendente:   { bg: "rgba(247,145,106,0.12)", text: "#F7916A", label: "Pendente"   },
  confirmado: { bg: "rgba(124,106,247,0.12)", text: "#7C6AF7", label: "Confirmado" },
  recebido:   { bg: "rgba(0,212,170,0.12)",   text: "#00D4AA", label: "Recebido"   },
  cancelado:  { bg: "rgba(247,100,100,0.12)", text: "#F76464", label: "Cancelado"  },
};

// Quais transições são permitidas por status atual
const TRANSITIONS = {
  pendente:   [{ value: "confirmado", label: "✓ Confirmar",  color: "#7C6AF7" },
               { value: "cancelado",  label: "✕ Cancelar",   color: "#F76464" }],
  confirmado: [{ value: "recebido",   label: "📦 Receber",    color: "#00D4AA" },
               { value: "cancelado",  label: "✕ Cancelar",   color: "#F76464" }],
  recebido:   [],
  cancelado:  [],
};

// ── Sub-componentes ─────────────────────────────────────────────────────────────

const StatusBadge = ({ status }) => {
  const m = STATUS_META[status] ?? STATUS_META.pendente;
  return (
    <span style={{
      display: "inline-flex", padding: "3px 10px", borderRadius: 99,
      background: m.bg, color: m.text,
      fontSize: 11, fontWeight: 600, whiteSpace: "nowrap",
    }}>
      {m.label}
    </span>
  );
};

// Linha de item do formulário de criação
const ItemRow = ({ item, index, products, onChange, onRemove }) => (
  <div style={{
    display: "grid", gridTemplateColumns: "1fr 80px 110px 32px",
    gap: 8, alignItems: "center",
  }}>
    <select
      className="input"
      value={item.product_id}
      onChange={(e) => onChange(index, "product_id", e.target.value)}
    >
      <option value="">Selecione o produto</option>
      {products.map((p) => (
        <option key={p.id} value={p.id}>{p.name}</option>
      ))}
    </select>
    <input
      className="input"
      type="number" min="1"
      placeholder="Qtd"
      value={item.quantity}
      onChange={(e) => onChange(index, "quantity", e.target.value)}
    />
    <input
      className="input"
      type="number" min="0" step="0.01"
      placeholder="Custo un."
      value={item.unit_cost}
      onChange={(e) => onChange(index, "unit_cost", e.target.value)}
    />
    <button
      onClick={() => onRemove(index)}
      style={{
        width: 32, height: 32, borderRadius: 7,
        border: "1px solid rgba(247,100,100,0.2)",
        background: "rgba(247,100,100,0.08)",
        color: "#F76464", cursor: "pointer", fontSize: 16,
        display: "flex", alignItems: "center", justifyContent: "center",
      }}
    >×</button>
  </div>
);

// Modal de detalhes de uma ordem
const OrderDetailModal = ({ order, onClose, onStatusChange, loadingAction }) => {
  if (!order) return null;
  const transitions = TRANSITIONS[order.status] ?? [];

  return (
    <div style={{
      position: "fixed", inset: 0, zIndex: 1000,
      background: "rgba(0,0,0,0.6)", backdropFilter: "blur(4px)",
      display: "flex", alignItems: "center", justifyContent: "center",
    }}
      onClick={(e) => { if (e.target === e.currentTarget) onClose(); }}
    >
      <div style={{
        background: "#13131A", border: "1px solid rgba(255,255,255,0.08)",
        borderRadius: 16, padding: 28, width: "100%", maxWidth: 520,
        maxHeight: "90vh", overflowY: "auto",
        boxShadow: "0 24px 64px rgba(0,0,0,0.6)",
      }}>
        {/* Header */}
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 20 }}>
          <div>
            <div style={{ fontSize: 16, fontWeight: 700, color: "#F0F0F8", marginBottom: 4 }}>
              Pedido de Compra #{order.id}
            </div>
            <StatusBadge status={order.status} />
          </div>
          <button onClick={onClose} style={{
            background: "none", border: "none", color: "#7A7A9A",
            cursor: "pointer", fontSize: 20, lineHeight: 1, padding: 4,
          }}>×</button>
        </div>

        {/* Info */}
        <div style={{
          display: "grid", gridTemplateColumns: "1fr 1fr",
          gap: 12, marginBottom: 20,
        }}>
          {[
            { label: "Fornecedor",  value: order.supplier_name },
            { label: "Total",       value: formatCurrency(order.total) },
            { label: "Criado em",   value: order.created_at ? new Date(order.created_at).toLocaleDateString("pt-BR") : "—" },
            { label: "Observações", value: order.notes || "—" },
          ].map(({ label, value }) => (
            <div key={label} style={{
              background: "rgba(255,255,255,0.03)", borderRadius: 9,
              padding: "10px 14px",
              border: "1px solid rgba(255,255,255,0.06)",
            }}>
              <div style={{ fontSize: 10, color: "#7A7A9A", fontWeight: 600,
                textTransform: "uppercase", letterSpacing: "0.8px", marginBottom: 4 }}>
                {label}
              </div>
              <div style={{ fontSize: 13, color: "#F0F0F8", fontWeight: 500 }}>{value}</div>
            </div>
          ))}
        </div>

        {/* Itens */}
        <div style={{ marginBottom: 20 }}>
          <div style={{ fontSize: 11, fontWeight: 600, color: "#7A7A9A",
            textTransform: "uppercase", letterSpacing: "0.8px", marginBottom: 10 }}>
            Itens
          </div>
          <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
            {(order.items || []).map((item, i) => (
              <div key={i} style={{
                display: "flex", justifyContent: "space-between", alignItems: "center",
                background: "rgba(255,255,255,0.03)", borderRadius: 8,
                padding: "8px 14px", border: "1px solid rgba(255,255,255,0.05)",
              }}>
                <span style={{ fontSize: 13, color: "#F0F0F8" }}>{item.product_name}</span>
                <div style={{ display: "flex", gap: 16, alignItems: "center" }}>
                  <span style={{ fontSize: 12, color: "#7A7A9A" }}>
                    {item.quantity} un. × {formatCurrency(item.unit_cost)}
                  </span>
                  <span style={{ fontSize: 13, fontWeight: 600, color: "#F0F0F8", fontFamily: "var(--font-mono)" }}>
                    {formatCurrency(item.quantity * item.unit_cost)}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Ações de transição */}
        {transitions.length > 0 && (
          <div style={{ display: "flex", gap: 10, justifyContent: "flex-end" }}>
            {transitions.map((t) => (
              <button
                key={t.value}
                disabled={loadingAction}
                onClick={() => onStatusChange(order.id, t.value)}
                style={{
                  padding: "9px 18px", borderRadius: 9, border: "none",
                  background: `${t.color}22`, color: t.color,
                  fontSize: 13, fontWeight: 600, cursor: loadingAction ? "not-allowed" : "pointer",
                  transition: "background 150ms",
                  opacity: loadingAction ? 0.6 : 1,
                }}
                onMouseEnter={(e) => { if (!loadingAction) e.currentTarget.style.background = `${t.color}33`; }}
                onMouseLeave={(e) => { e.currentTarget.style.background = `${t.color}22`; }}
              >
                {loadingAction ? "…" : t.label}
              </button>
            ))}
          </div>
        )}

        {order.status === "recebido" && (
          <div style={{ textAlign: "center", padding: "10px 0 0",
            fontSize: 12, color: "#00D4AA", fontWeight: 500 }}>
            ✓ Ordem recebida — estoque atualizado automaticamente
          </div>
        )}
      </div>
    </div>
  );
};

// ── Formulário de nova ordem ────────────────────────────────────────────────────

const EMPTY_ITEM = () => ({ product_id: "", quantity: 1, unit_cost: "" });

const NewOrderForm = ({ suppliers, products, onCreated }) => {
  const [supplierId, setSupplierId] = useState("");
  const [notes, setNotes]           = useState("");
  const [items, setItems]           = useState([EMPTY_ITEM()]);
  const [saving, setSaving]         = useState(false);

  const updateItem = (i, field, value) => {
    setItems((prev) => prev.map((it, idx) => idx === i ? { ...it, [field]: value } : it));
  };
  const addItem    = () => setItems((prev) => [...prev, EMPTY_ITEM()]);
  const removeItem = (i) => setItems((prev) => prev.filter((_, idx) => idx !== i));

  const total = items.reduce((s, it) =>
    s + (Number(it.quantity) || 0) * (Number(it.unit_cost) || 0), 0
  );

  const handleSubmit = async () => {
    if (!supplierId) return notificationService.error("Selecione um fornecedor");
    if (items.some((it) => !it.product_id || !it.quantity || !it.unit_cost))
      return notificationService.error("Preencha todos os campos dos itens");

    setSaving(true);
    try {
      await api.post("/purchase-orders", {
        supplier_id: supplierId,
        notes: notes || undefined,
        items: items.map((it) => ({
          product_id: Number(it.product_id),
          quantity:   Number(it.quantity),
          unit_cost:  Number(it.unit_cost),
        })),
      });
      notificationService.success("Pedido de compra criado!");
      setSupplierId(""); setNotes(""); setItems([EMPTY_ITEM()]);
      onCreated();
    } catch (err) {
      notificationService.error(errorService.handle(err, "criar pedido de compra"));
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="chart-card" style={{ marginBottom: 20 }}>
      <div className="chart-header">
        <div className="chart-title">+ Novo pedido de compra</div>
      </div>

      {/* Fornecedor + Observações */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12, marginBottom: 16 }}>
        <div>
          <label className="form-label">Fornecedor *</label>
          <select className="input" value={supplierId} onChange={(e) => setSupplierId(e.target.value)}>
            <option value="">Selecione...</option>
            {suppliers.map((s) => <option key={s.id} value={s.id}>{s.name}</option>)}
          </select>
        </div>
        <div>
          <label className="form-label">Observações</label>
          <input className="input" value={notes} onChange={(e) => setNotes(e.target.value)} placeholder="Opcional" />
        </div>
      </div>

      {/* Itens */}
      <div style={{ marginBottom: 12 }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 8 }}>
          <label className="form-label" style={{ margin: 0 }}>Itens *</label>
          {/* Header de colunas */}
          <div style={{ display: "grid", gridTemplateColumns: "1fr 80px 110px 32px",
            gap: 8, width: "calc(100% - 60px)", fontSize: 10, fontWeight: 600,
            color: "#7A7A9A", textTransform: "uppercase", letterSpacing: "0.6px" }}>
            <span>Produto</span>
            <span>Qtd</span>
            <span>Custo un.</span>
            <span />
          </div>
        </div>
        <div style={{ display: "flex", gap: 8 }}>
          <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: 8 }}>
            {items.map((item, i) => (
              <ItemRow
                key={i} index={i} item={item}
                products={products}
                onChange={updateItem}
                onRemove={removeItem}
              />
            ))}
          </div>
        </div>
      </div>

      {/* Footer do form */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <button
          onClick={addItem}
          style={{
            padding: "7px 14px", borderRadius: 8,
            border: "1px dashed rgba(124,106,247,0.3)",
            background: "rgba(124,106,247,0.06)", color: "#7C6AF7",
            fontSize: 12, fontWeight: 600, cursor: "pointer",
          }}
        >
          + Adicionar item
        </button>

        <div style={{ display: "flex", alignItems: "center", gap: 16 }}>
          {total > 0 && (
            <span style={{ fontSize: 13, fontWeight: 600, color: "#F0F0F8" }}>
              Total: {formatCurrency(total)}
            </span>
          )}
          <button
            onClick={handleSubmit}
            disabled={saving}
            className="btn btn-primary"
            style={{ opacity: saving ? 0.7 : 1 }}
          >
            {saving ? "Salvando…" : "Criar pedido"}
          </button>
        </div>
      </div>
    </div>
  );
};

// ── Página principal ────────────────────────────────────────────────────────────

const PurchaseOrders = () => {
  const [statusFilter,   setStatusFilter]   = useState("todos");
  const [supplierFilter, setSupplierFilter] = useState("todos");
  const [search,         setSearch]         = useState("");
  const [selected,       setSelected]       = useState(null);
  const [loadingAction,  setLoadingAction]  = useState(false);

  const { data: rawOrders,   loading,   refetch }            = useFetch("/purchase-orders", true, 0);
  const { data: suppliers,   loading: loadingSup }           = useFetch("/suppliers",       true, 5 * 60 * 1000);
  const { data: products,    loading: loadingProd }          = useFetch("/products",        true, 5 * 60 * 1000);

  const orders = rawOrders || [];

  // Filtros
  const filtered = useMemo(() => {
    return orders.filter((o) => {
      const matchStatus   = statusFilter   === "todos" || o.status === statusFilter;
      const matchSupplier = supplierFilter === "todos" || String(o.supplier_id) === supplierFilter;
      const matchSearch   = !search || [o.supplier_name, String(o.id)]
        .some((f) => (f ?? "").toLowerCase().includes(search.toLowerCase()));
      return matchStatus && matchSupplier && matchSearch;
    });
  }, [orders, statusFilter, supplierFilter, search]);

  const { paginatedItems, currentPage, goToPage, totalPages } = usePagination(filtered, 10);

  // KPIs rápidos
  const kpis = useMemo(() => ({
    total:      orders.length,
    pendente:   orders.filter((o) => o.status === "pendente").length,
    confirmado: orders.filter((o) => o.status === "confirmado").length,
    recebido:   orders.filter((o) => o.status === "recebido").length,
  }), [orders]);

  const handleStatusChange = useCallback(async (id, newStatus) => {
    setLoadingAction(true);
    try {
      await api.patch(`/purchase-orders/${id}/status`, { status: newStatus });
      notificationService.success(
        newStatus === "recebido"
          ? "Ordem recebida — estoque atualizado!"
          : `Status atualizado para ${newStatus}`
      );
      setSelected(null);
      refetch();
    } catch (err) {
      notificationService.error(errorService.handle(err, "atualizar status"));
    } finally {
      setLoadingAction(false);
    }
  }, [refetch]);

  const handleDelete = useCallback(async (id) => {
    try {
      await api.delete(`/purchase-orders/${id}`);
      notificationService.success("Pedido de compra removido");
      refetch();
    } catch (err) {
      notificationService.error(errorService.handle(err, "remover pedido de compra"));
    }
  }, [refetch]);

  // Abre modal de detalhe ao clicar em editar
  const handleView = useCallback((order) => {
    setSelected(order);
  }, []);

  const supplierOptions = useMemo(() =>
    ["todos", ...(suppliers || []).map((s) => String(s.id))],
    [suppliers]
  );

  return (
    <div className="main-content">
      <PageShell
        title="Pedidos de Compra"
        count={loading ? null : filtered.length}
        icon={ICON_PATH}
        description="Gerencie ordens de compra com fornecedores"
        actions={
          <>
            <input
              className="input"
              placeholder="Buscar fornecedor, ID..."
              value={search}
              onChange={(e) => { setSearch(e.target.value); goToPage(1); }}
              style={{ width: 200 }}
            />
            <select
              className="input"
              value={statusFilter}
              onChange={(e) => { setStatusFilter(e.target.value); goToPage(1); }}
              style={{ width: 140 }}
            >
              <option value="todos">Todos status</option>
              {Object.entries(STATUS_META).map(([v, m]) => (
                <option key={v} value={v}>{m.label}</option>
              ))}
            </select>
            <select
              className="input"
              value={supplierFilter}
              onChange={(e) => { setSupplierFilter(e.target.value); goToPage(1); }}
              style={{ width: 160 }}
            >
              <option value="todos">Todos fornecedores</option>
              {(suppliers || []).map((s) => (
                <option key={s.id} value={String(s.id)}>{s.name}</option>
              ))}
            </select>
          </>
        }
      />

      <div className="page-body">
        {/* KPIs */}
        <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 12, marginBottom: 20 }}>
          {[
            { label: "Total",      value: kpis.total,      color: "#7C6AF7" },
            { label: "Pendentes",  value: kpis.pendente,   color: "#F7916A" },
            { label: "Confirmados",value: kpis.confirmado, color: "#7C6AF7" },
            { label: "Recebidos",  value: kpis.recebido,   color: "#00D4AA" },
          ].map(({ label, value, color }) => (
            <div key={label} style={{
              background: "#13131A", border: "1px solid rgba(255,255,255,0.06)",
              borderRadius: 12, padding: "14px 18px",
            }}>
              <div style={{ fontSize: 10, fontWeight: 600, color: "#7A7A9A",
                textTransform: "uppercase", letterSpacing: "0.8px", marginBottom: 6 }}>
                {label}
              </div>
              <div style={{ fontSize: 24, fontWeight: 700, color }}>{value}</div>
            </div>
          ))}
        </div>

        {/* Formulário de nova ordem */}
        {!loadingSup && !loadingProd && (
          <NewOrderForm
            suppliers={suppliers || []}
            products={products || []}
            onCreated={refetch}
          />
        )}

        {/* Tabela */}
        <div className="chart-card">
          <DataTable
            rows={paginatedItems}
            columns={[
              { key: "id", label: "ID",
                render: (v) => (
                  <span style={{ fontFamily: "var(--font-mono)", color: "var(--color-textMuted)" }}>
                    #{v}
                  </span>
                ),
              },
              { key: "supplier_name", label: "Fornecedor" },
              { key: "total", label: "Total",
                render: (v) => (
                  <span style={{ fontFamily: "var(--font-mono)", fontWeight: 600 }}>
                    {formatCurrency(v)}
                  </span>
                ),
              },
              { key: "status", label: "Status",
                render: (v) => <StatusBadge status={v} />,
              },
              { key: "items", label: "Itens",
                render: (v) => (
                  <span style={{ fontSize: 12, color: "#7A7A9A" }}>
                    {(v || []).length} produto{(v || []).length !== 1 ? "s" : ""}
                  </span>
                ),
              },
              { key: "created_at", label: "Data",
                render: (v) => v ? new Date(v).toLocaleDateString("pt-BR") : "—",
              },
              // Botões de ação inline para transições rápidas
              { key: "_actions", label: "Ações",
                render: (_, row) => {
                  const transitions = TRANSITIONS[row.status] ?? [];
                  return (
                    <div style={{ display: "flex", gap: 6 }}>
                      <button
                        onClick={(e) => { e.stopPropagation(); handleView(row); }}
                        style={{
                          padding: "4px 10px", borderRadius: 6, border: "1px solid rgba(124,106,247,0.25)",
                          background: "rgba(124,106,247,0.08)", color: "#7C6AF7",
                          fontSize: 11, fontWeight: 600, cursor: "pointer",
                        }}
                      >
                        Detalhes
                      </button>
                      {transitions.slice(0, 1).map((t) => (
                        <button
                          key={t.value}
                          onClick={(e) => { e.stopPropagation(); handleStatusChange(row.id, t.value); }}
                          style={{
                            padding: "4px 10px", borderRadius: 6,
                            border: `1px solid ${t.color}33`,
                            background: `${t.color}11`, color: t.color,
                            fontSize: 11, fontWeight: 600, cursor: "pointer",
                            whiteSpace: "nowrap",
                          }}
                        >
                          {t.label}
                        </button>
                      ))}
                    </div>
                  );
                },
              },
            ]}
            onEdit={handleView}
            onDelete={(id) => {
              const order = orders.find((o) => o.id === id);
              if (order?.status !== "pendente")
                return notificationService.error("Só é possível remover ordens pendentes");
              if (window.confirm("Remover este pedido de compra?")) handleDelete(id);
            }}
            isLoading={loading}
            emptyMessage="Nenhum pedido de compra encontrado"
          />
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} />
        </div>
      </div>

      {/* Modal de detalhe/transição */}
      <OrderDetailModal
        order={selected}
        onClose={() => setSelected(null)}
        onStatusChange={handleStatusChange}
        loadingAction={loadingAction}
      />
    </div>
  );
};

export default PurchaseOrders;
