import React, { useEffect, useRef, useState, useMemo } from "react";
import { useFetch, useSearch, usePagination } from "../hooks";
import { GLOBAL_STYLES } from "../constants/styles";
import { API_ENDPOINTS } from "../constants";
import api from "../services/api";
import errorService from "../services/errorService";
import notificationService from "../services/notificationService";
import { useAuth } from "../contexts/AuthContext";
import DataTable from "../components/DataTable";
import OrderForm from "../components/OrderForm";

const STATUS_BADGE = {
  pendente: "badge-yellow",
  aprovado: "badge-green",
  cancelado: "badge-red",
  entregue: "badge-blue",
};

const Orders = () => {
  const { user, logout } = useAuth();
  const formRef = useRef(null);
  const [editingOrder, setEditingOrder] = useState(null);
  const [statusFilter, setStatusFilter] = useState("todos");

  // Hooks customizados
  const { data: orders, loading, error, refetch } = useFetch(
    API_ENDPOINTS.ORDERS,
    true,
    5 * 60 * 1000
  );

  const { search, setSearch, filtered: searchFiltered } = useSearch(orders || [], [
    "client",
    "id",
  ]);

  // Aplicar filtro de status
  const filtered = useMemo(() => {
    return searchFiltered.filter(o => {
      return statusFilter === "todos" || o.status === statusFilter;
    });
  }, [searchFiltered, statusFilter]);

  const { paginatedItems, currentPage, goToPage, totalPages } = usePagination(
    filtered,
    10
  );

  // Extrair statuses únicos
  const statuses = useMemo(() => {
    return ["todos", ...new Set(orders.map(o => o.status).filter(Boolean))];
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

  const handleCancel = () => {
    setEditingOrder(null);
  };

  if (error) {
    return (
      <div style={{ padding: "20px", textAlign: "center" }}>
        <p style={{ color: "#ef4444" }}>Erro: {error}</p>
      </div>
    );
  }

  return (
    <>
      <style>{GLOBAL_STYLES}</style>
      <div className="main-content">
          <div className="topbar">
            <div className="topbar-title">Pedidos</div>
            <div className="topbar-right">
              <input
                className="date-input"
                placeholder="🔍 Buscar pedido..."
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                style={{ width: 200 }}
              />
              <select
                className="date-input"
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
                style={{
                  padding: "8px 12px",
                  backgroundColor: "#17171f",
                  border: "1px solid rgba(255,255,255,0.06)",
                  borderRadius: "6px",
                  color: "#e8e8f0",
                  cursor: "pointer",
                }}
              >
                {statuses.map(s => (
                  <option key={s} value={s}>
                    {s.charAt(0).toUpperCase() + s.slice(1)}
                  </option>
                ))}
              </select>
            </div>
          </div>

          <div className="page-body">
            {/* Formulário */}
            <div ref={formRef} className="fade-up">
              <div className="form-card">
                <div className="form-title-sm">
                  {editingOrder 
                    ? "✏️ Editar Pedido" 
                    : "➕ Novo Pedido"}
                </div>
                <OrderForm
                  onOrderCreated={refetch}
                  editingOrder={editingOrder}
                  onCancel={handleCancel}
                />
              </div>
            </div>

            {/* Tabela */}
            <div className="chart-card fade-up fade-up-2">
              <div
                style={{
                  display: "flex",
                  justifyContent: "space-between",
                  alignItems: "center",
                  marginBottom: 16,
                }}
              >
                <div className="chart-title" style={{ marginBottom: 0 }}>
                  Lista de Pedidos
                  <span
                    className="badge badge-blue"
                    style={{ marginLeft: 10 }}
                  >
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
                    render: (value) => `#${value}`
                  },
                  { key: "client", label: "Cliente" },
                  { 
                    key: "total_amount", 
                    label: "Total",
                    render: (value) => `R$ ${Number(value).toFixed(2)}`
                  },
                  {
                    key: "status",
                    label: "Status",
                    render: (value) => (
                      <span style={{
                        padding: "4px 8px",
                        backgroundColor: value === "pendente" ? "rgba(245,158,11,0.2)" :
                                         value === "aprovado" ? "rgba(34,197,94,0.2)" :
                                         value === "entregue" ? "rgba(79,110,247,0.2)" :
                                         "rgba(239,68,68,0.2)",
                        color: value === "pendente" ? "#f59e0b" :
                               value === "aprovado" ? "#22c55e" :
                               value === "entregue" ? "#4f6ef7" :
                               "#ef4444",
                        borderRadius: "4px",
                        fontSize: "12px",
                        fontWeight: "500",
                        textTransform: "capitalize",
                      }}>
                        {value}
                      </span>
                    ),
                  },
                ]}
                onEdit={handleEditOrder}
                onDelete={handleDeleteOrder}
                isLoading={loading}
                emptyMessage="Nenhum pedido encontrado"
              />

              {/* Paginação */}
              {totalPages > 1 && (
                <div
                  style={{
                    display: "flex",
                    gap: "8px",
                    justifyContent: "center",
                    marginTop: "20px",
                    flexWrap: "wrap",
                  }}
                >
                  <button
                    onClick={() => goToPage(currentPage - 1)}
                    disabled={currentPage === 1}
                    style={{
                      padding: "8px 12px",
                      backgroundColor: currentPage === 1 ? "#555" : "#4f6ef7",
                      color: "white",
                      border: "none",
                      borderRadius: "6px",
                      cursor:
                        currentPage === 1 ? "not-allowed" : "pointer",
                      opacity: currentPage === 1 ? 0.5 : 1,
                    }}
                  >
                    ← Anterior
                  </button>

                  {Array.from({ length: totalPages }, (_, i) => (
                    <button
                      key={i + 1}
                      onClick={() => goToPage(i + 1)}
                      style={{
                        padding: "8px 12px",
                        backgroundColor:
                          currentPage === i + 1 ? "#06b6d4" : "#17171f",
                        color: "white",
                        border: "1px solid rgba(255,255,255,0.06)",
                        borderRadius: "6px",
                        cursor: "pointer",
                      }}
                    >
                      {i + 1}
                    </button>
                  ))}

                  <button
                    onClick={() => goToPage(currentPage + 1)}
                    disabled={currentPage === totalPages}
                    style={{
                      padding: "8px 12px",
                      backgroundColor:
                        currentPage === totalPages ? "#555" : "#4f6ef7",
                      color: "white",
                      border: "none",
                      borderRadius: "6px",
                      cursor:
                        currentPage === totalPages
                          ? "not-allowed"
                          : "pointer",
                      opacity: currentPage === totalPages ? 0.5 : 1,
                    }}
                  >
                    Próximo →
                  </button>
                </div>
              )}
            </div>
          </div>
        </div>
    </>
  );
};

export default Orders;
