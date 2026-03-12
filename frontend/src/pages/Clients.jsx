import React, { useEffect, useRef, useState } from "react";
import { useFetch, useSearch, useForm, usePagination } from "../hooks";
import { GLOBAL_STYLES } from "../constants/styles";
import { API_ENDPOINTS } from "../constants";
import api from "../services/api";
import errorService from "../services/errorService";
import notificationService from "../services/notificationService";
import { useAuth } from "../contexts/AuthContext";
import DataTable from "../components/DataTable";
import DataForm from "../components/DataForm";

const Clients = () => {
  const { user, logout } = useAuth();
  const formRef = useRef(null);
  const [editingClient, setEditingClient] = useState(null);

  // Hooks customizados
  const { data: clients, loading, error, refetch } = useFetch(
    API_ENDPOINTS.CLIENTS,
    true,
    5 * 60 * 1000 // 5 minutos de cache
  );

  const { search, setSearch, filtered } = useSearch(clients || [], [
    "name",
    "email",
  ]);

  const { paginatedItems, currentPage, goToPage, totalPages } = usePagination(
    filtered,
    10
  );

  const initialValues = {
    name: editingClient?.name || "",
    email: editingClient?.email || "",
  };

  const {
    values,
    errors,
    touched,
    isSubmitting,
    handleChange,
    handleBlur,
    handleSubmit: formSubmit,
    resetForm,
    setFieldValue,
    setFieldTouched,
  } = useForm(initialValues, async (formData) => {
    try {
      if (editingClient) {
        await api.put(`${API_ENDPOINTS.CLIENTS}/${editingClient.id}`, formData);
        notificationService.success("Cliente atualizado com sucesso!");
      } else {
        await api.post(API_ENDPOINTS.CLIENTS, formData);
        notificationService.success("Cliente criado com sucesso!");
      }

      setEditingClient(null);
      resetForm();
      refetch();
    } catch (err) {
      const message = errorService.handle(err, "criação/atualização do cliente");
      notificationService.error(message);
    }
  });

  const handleEditClient = (client) => {
    setEditingClient(client);
    setFieldValue("name", client.name);
    setFieldValue("email", client.email);
    if (formRef.current) {
      formRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  };

  const handleDeleteClient = async (id) => {
    try {
      await api.delete(`${API_ENDPOINTS.CLIENTS}/${id}`);
      notificationService.success("Cliente deletado com sucesso!");
      refetch();
    } catch (err) {
      const message = errorService.handle(err, "deleção do cliente");
      notificationService.error(message);
    }
  };

  const handleCancel = () => {
    setEditingClient(null);
    resetForm();
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
            <div className="topbar-title">Clientes</div>
            <div className="topbar-right">
              <input
                className="date-input"
                placeholder="🔍 Buscar cliente..."
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                style={{ width: 220 }}
              />
            </div>
          </div>

          <div className="page-body">
            {/* Formulário */}
            <div ref={formRef} className="fade-up">
              <div className="form-card">
                <div className="form-title-sm">
                  {editingClient ? "✏️ Editar Cliente" : "➕ Novo Cliente"}
                </div>
                <DataForm
                  fields={[
                    {
                      name: "name",
                      label: "Nome",
                      type: "text",
                      placeholder: "Digite o nome",
                      required: true,
                    },
                    {
                      name: "email",
                      label: "Email",
                      type: "email",
                      placeholder: "Digite o email",
                      required: true,
                    },
                  ]}
                  values={values}
                  errors={errors}
                  touched={touched}
                  isSubmitting={isSubmitting}
                  onSubmit={formSubmit}
                  onCancel={editingClient ? handleCancel : null}
                  onFieldChange={(name, value) => {
                    setFieldValue(name, value);
                  }}
                  onFieldBlur={(name) => setFieldTouched(name, true)}
                  submitLabel={editingClient ? "Atualizar" : "Adicionar"}
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
                  Todos os Clientes
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
                  { key: "name", label: "Nome" },
                  { key: "email", label: "Email" },
                ]}
                onEdit={handleEditClient}
                onDelete={handleDeleteClient}
                isLoading={loading}
                emptyMessage="Nenhum cliente encontrado"
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

export default Clients;
