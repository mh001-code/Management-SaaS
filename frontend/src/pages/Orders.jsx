import React, { useRef, useState, useMemo } from "react";
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

const STATUS_STYLE = {
  pendente:   { bg: "rgba(247,145,106,0.1)", text: "#F7916A" },
  pago:       { bg: "rgba(0,212,170,0.1)",   text: "#00D4AA" },
  enviado:    { bg: "rgba(124,106,247,0.1)", text: "#7C6AF7" },
  entregue:   { bg: "rgba(0,212,170,0.1)",   text: "#00D4AA" },
  "concluído":{ bg: "rgba(0,212,170,0.1)",   text: "#00D4AA" },
  cancelado:  { bg: "rgba(247,100,100,0.1)", text: "#F76464" },
  estornado:  { bg: "rgba(122,122,154,0.1)", text: "#7A7A9A" },
  recusado:   { bg: "rgba(247,100,100,0.1)", text: "#F76464" },
};

const StatusBadge = ({ status }) => {
  const s = STATUS_STYLE[status] ?? STATUS_STYLE.pendente;
  return (
    <span style={{
      display: "inline-flex", padding: "3px 10px", borderRadius: 99,
      background: s.bg, color: s.text,
      fontSize: 11, fontWeight: 600, whiteSpace: "nowrap",
    }}>
      {status}
    </span>
  );
};

const ICON_PATH = "M3 5h14M3 10h14M3 15h8";

const Orders = () => {
  const formRef = useRef(null);
  const [editingOrder, setEditingOrder] = useState(null);
  const [statusFilter, setStatusFilter] = useState("todos");

  const { data: rawOrders, loading, error, refetch } = useFetch(
    API_ENDPOINTS.ORDERS, true, 5 * 60 * 1000
  );

  const orders = useMemo(() =>
    (rawOrders || []).map((o) => ({
      ...o,
      id: o.order_id ?? o.id,
      client: o.client_name ?? o.client,
      total_amount: o.total ?? o.total_amount,
    })), [rawOrders]
  );

  const { search, setSearch, filtered: searchFiltered } = useSearch(orders, ["client", "id"]);

  const filtered = useMemo(() =>
    searchFiltered.filter((o) => statusFilter === "todos" || o.status === statusFilter),
    [searchFiltered, statusFilter]
  );

  const statuses = useMemo(() =>
    ["todos", ...new Set(orders.map((o) => o.status).filter(Boolean))],
    [orders]
  );

  const { paginatedItems, currentPage, goToPage, totalPages } = usePagination(filtered, 10);

  const handleEdit = (order) => {
    setEditingOrder(order);
    formRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
  };

  const handleDelete = async (id) => {
    try {
      await api.delete(`${API_ENDPOINTS.ORDERS}/${id}`);
      notificationService.success("Pedido deletado!");
      refetch();
    } catch (err) {
      notificationService.error(errorService.handle(err, "deletar pedido"));
    }
  };

  return (
    <div className="main-content">
      <PageShell
        title="Pedidos"
        count={loading ? null : filtered.length}
        icon={ICON_PATH}
        description="Gerencie pedidos e acompanhe status"
        actions={
          <>
            <input
              className="input"
              placeholder="Buscar pedido..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              style={{ width: 200 }}
            />
            <select
              className="input"
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              style={{ width: 150 }}
            >
              {statuses.map((s) => (
                <option key={s} value={s}>
                  {s.charAt(0).toUpperCase() + s.slice(1)}
                </option>
              ))}
            </select>
          </>
        }
      />

      <div className="page-body">
        {error && <div className="alert alert-danger">{error}</div>}

        <div ref={formRef}>
          <div className="chart-card">
            <div className="chart-header">
              <div className="chart-title">
                {editingOrder ? "✎ Editar pedido" : "+ Novo pedido"}
              </div>
            </div>
            <OrderForm
              onOrderCreated={refetch}
              editingOrder={editingOrder}
              onCancel={() => setEditingOrder(null)}
            />
          </div>
        </div>

        <div className="chart-card">
          <DataTable
            rows={paginatedItems}
            columns={[
              { key: "id",           label: "ID",
                render: (v) => <span style={{ fontFamily: "var(--font-mono)", color: "var(--color-textMuted)" }}>#{v}</span> },
              { key: "client",       label: "Cliente" },
              { key: "total_amount", label: "Total",
                render: (v) => <span style={{ fontFamily: "var(--font-mono)", fontWeight: 600 }}>{formatCurrency(v)}</span> },
              { key: "status",       label: "Status",
                render: (v) => <StatusBadge status={v} /> },
              { key: "created_at",   label: "Data",
                render: (v) => v ? new Date(v).toLocaleDateString("pt-BR") : "—" },
            ]}
            onEdit={handleEdit}
            onDelete={handleDelete}
            isLoading={loading}
            emptyMessage="Nenhum pedido encontrado"
            emptyIcon="orders"
          />
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} />
        </div>
      </div>
    </div>
  );
};

export default Orders;
