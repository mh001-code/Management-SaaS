import React, { useRef, useState, useMemo } from "react";
import { useFetch, useSearch, usePagination } from "../hooks";
import { API_ENDPOINTS } from "../constants";
import api from "../services/api";
import errorService from "../services/errorService";
import notificationService from "../services/notificationService";
import { formatCurrency } from "../utils/formatCurrency";
import DataTable from "../components/DataTable";
import OrderForm from "../components/OrderForm";
import Pagination from "../components/Pagination";
import Card from "../components/ui/Card";
import Input from "../components/ui/Input";

const STATUS_COLORS = {
  pendente:  { bg: "rgba(245, 158, 11, 0.15)",  text: "#f59e0b", label: "Pendente"  },
  pago:      { bg: "rgba(34, 197, 94, 0.15)",   text: "#22c55e", label: "Pago"      },
  enviado:   { bg: "rgba(59, 130, 246, 0.15)",  text: "#3b82f6", label: "Enviado"   },
  entregue:  { bg: "rgba(79, 110, 247, 0.15)",  text: "#4f6ef7", label: "Entregue"  },
  concluído: { bg: "rgba(34, 197, 94, 0.15)",   text: "#22c55e", label: "Concluído" },
  cancelado: { bg: "rgba(239, 68, 68, 0.15)",   text: "#ef4444", label: "Cancelado" },
  estornado: { bg: "rgba(249, 115, 22, 0.15)",  text: "#f97316", label: "Estornado" },
  recusado:  { bg: "rgba(239, 68, 68, 0.15)",   text: "#dc2626", label: "Recusado"  },
};

const Orders = () => {
  const formRef = useRef(null);
  const [editingOrder, setEditingOrder] = useState(null);
  const [statusFilter, setStatusFilter] = useState("todos");

  const { data: rawOrders, loading, error, refetch } = useFetch(
    API_ENDPOINTS.ORDERS,
    true,
    5 * 60 * 1000
  );

  const orders = useMemo(() => {
    return (rawOrders || []).map((order) => ({
      ...order,
      id: order.order_id || order.id,
      client: order.client_name || order.client,
      total_amount: order.total || order.total_amount,
    }));
  }, [rawOrders]);

  const { search, setSearch, filtered: searchFiltered } = useSearch(orders, [
    "client",
    "id",
  ]);

  const filtered = useMemo(() => {
    return searchFiltered.filter(
      (o) => statusFilter === "todos" || o.status === statusFilter
    );
  }, [searchFiltered, statusFilter]);

  const { paginatedItems, currentPage, goToPage, totalPages } = usePagination(
    filtered,
    10
  );

  const statuses = useMemo(() => {
    return ["todos", ...new Set(orders.map((o) => o.status).filter(Boolean))];
  }, [orders]);

  const handleEditOrder = (order) => {
    setEditingOrder(order);
    if (formRef.current) {
      formRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  };

  const handleDeleteOrder = async (id) => {
    try {
      await api.delete(`${API_ENDPOINTS.ORDERS}/${id}`);
      notificationService.success("Pedido deletado com sucesso!");
      refetch();
    } catch (err) {
      const message = errorService.handle(err, "deleção do pedido");
      notificationService.error(message);
    }
  };

  const handleCancel = () => setEditingOrder(null);

  if (error) {
    return (
      <div style={{ padding: "20px", textAlign: "center" }}>
        <p style={{ color: "#ef4444" }}>Erro: {error}</p>
      </div>
    );
  }

  return (
    <div className="main-content">
      <div className="topbar">
        <div className="topbar-title">Pedidos</div>
        <div className="topbar-right">
          <Input
            placeholder="🔍 Buscar pedido..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            className="input"
          >
            {statuses.map((s) => (
              <option key={s} value={s}>
                {s.charAt(0).toUpperCase() + s.slice(1)}
              </option>
            ))}
          </select>
        </div>
      </div>

      <div className="page-body">
        {/* Formulário */}
        <div ref={formRef} className="animate-fadeUp">
          <Card title={editingOrder ? "✏️ Editar Pedido" : "➕ Novo Pedido"}>
            <OrderForm
              onOrderCreated={refetch}
              editingOrder={editingOrder}
              onCancel={handleCancel}
            />
          </Card>
        </div>

        {/* Tabela */}
        <div className="chart-card animate-fadeUp">
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
            <div className="chart-title" style={{ marginBottom: 0 }}>
              Lista de Pedidos
              <span className="badge badge-blue" style={{ marginLeft: 10 }}>
                {filtered.length}
              </span>
            </div>
          </div>

          <DataTable
            rows={paginatedItems}
            columns={[
              {
                key: "id",
                label: "ID",
                render: (value) => `#${value}`,
              },
              { key: "client", label: "Cliente" },
              {
                key: "total_amount",
                label: "Total",
                render: (value) => formatCurrency(value),
              },
              {
                key: "status",
                label: "Status",
                render: (value) => {
                  const color = STATUS_COLORS[value] || STATUS_COLORS.pendente;
                  return (
                    <span style={{
                      display: "inline-block",
                      padding: "6px 12px",
                      backgroundColor: color.bg,
                      color: color.text,
                      borderRadius: "var(--radius-md)",
                      fontSize: "var(--text-sm)",
                      fontWeight: "600",
                      border: `1px solid ${color.text}20`,
                      whiteSpace: "nowrap",
                    }}>
                      {color.label}
                    </span>
                  );
                },
              },
            ]}
            onEdit={handleEditOrder}
            onDelete={handleDeleteOrder}
            isLoading={loading}
            emptyMessage="Nenhum pedido encontrado"
          />

          <Pagination
            currentPage={currentPage}
            totalPages={totalPages}
            onPageChange={goToPage}
          />
        </div>
      </div>
    </div>
  );
};

export default Orders;