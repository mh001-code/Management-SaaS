import React, { useEffect, useRef, useState } from "react";
import { useFetch, useSearch, useForm, usePagination } from "../hooks";
import { GLOBAL_STYLES } from "../constants/styles";
import { API_ENDPOINTS, USER_ROLES } from "../constants";
import api from "../services/api";
import errorService from "../services/errorService";
import notificationService from "../services/notificationService";
import { useAuth } from "../contexts/AuthContext";
import DataTable from "../components/DataTable";
import DataForm from "../components/DataForm";

const Users = () => {
  const { user, logout } = useAuth();
  const formRef = useRef(null);
  const [editingUser, setEditingUser] = useState(null);

  // Verificar permissão
  const isAdmin = user?.role === USER_ROLES.ADMIN;

  // Hooks customizados
  const { data: users, loading, error, refetch } = useFetch(
    isAdmin ? API_ENDPOINTS.USERS : null,
    isAdmin,
    5 * 60 * 1000
  );

  const { search, setSearch, filtered } = useSearch(users || [], [
    "name",
    "email",
  ]);

  const { paginatedItems, currentPage, goToPage, totalPages } = usePagination(
    filtered,
    10
  );

  const initialValues = {
    name: editingUser?.name || "",
    email: editingUser?.email || "",
    role: editingUser?.role || "user",
  };

  const {
    values,
    errors,
    touched,
    isSubmitting,
    handleSubmit: formSubmit,
    resetForm,
    setFieldValue,
    setFieldTouched,
  } = useForm(initialValues, async (formData) => {
    try {
      if (editingUser) {
        await api.put(
          `${API_ENDPOINTS.USERS}/${editingUser.id}`,
          formData
        );
        notificationService.success("Usuário atualizado com sucesso!");
      } else {
        // Para novo usuário, senha é obrigatória
        if (!formData.password) {
          notificationService.error("Senha é obrigatória para novo usuário");
          return;
        }
        await api.post(API_ENDPOINTS.USERS, formData);
        notificationService.success("Usuário criado com sucesso!");
      }

      setEditingUser(null);
      resetForm();
      refetch();
    } catch (err) {
      const message = errorService.handle(err, "criação/atualização do usuário");
      notificationService.error(message);
    }
  });

  const handleEditUser = (u) => {
    setEditingUser(u);
    setFieldValue("name", u.name);
    setFieldValue("email", u.email);
    setFieldValue("role", u.role || "user");
    if (formRef.current) {
      formRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  };

  const handleDeleteUser = async (id) => {
    try {
      await api.delete(`${API_ENDPOINTS.USERS}/${id}`);
      notificationService.success("Usuário deletado com sucesso!");
      refetch();
    } catch (err) {
      const message = errorService.handle(err, "deleção do usuário");
      notificationService.error(message);
    }
  };

  const handleCancel = () => {
    setEditingUser(null);
    resetForm();
  };

  // Sem permissão
  if (!isAdmin && !loading) {
    return (
      <div style={{ padding: "20px", textAlign: "center" }}>
        <div style={{
          padding: "40px",
          textAlign: "center",
          color: "rgba(255,255,255,0.5)",
        }}>
          <p style={{ fontSize: "18px", fontWeight: "500" }}>🔒 Sem permissão</p>
          <p>Você não tem permissão para acessar esta página.</p>
        </div>
      </div>
    );
  }

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
            <div className="topbar-title">Usuários</div>
            <div className="topbar-right">
              <input
                className="date-input"
                placeholder="🔍 Buscar usuário..."
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
                  {editingUser
                    ? "✏️ Editar Usuário"
                    : "➕ Novo Usuário"}
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
                    {
                      name: "role",
                      label: "Função",
                      type: "select",
                      options: [
                        { value: "user", label: "Usuário" },
                        { value: "admin", label: "Administrador" },
                      ],
                      required: true,
                    },
                    ...(editingUser ? [] : [
                      {
                        name: "password",
                        label: "Senha",
                        type: "password",
                        placeholder: "Digite a senha",
                        required: true,
                      },
                    ]),
                  ]}
                  values={values}
                  errors={errors}
                  touched={touched}
                  isSubmitting={isSubmitting}
                  onSubmit={formSubmit}
                  onCancel={editingUser ? handleCancel : null}
                  onFieldChange={(name, value) => {
                    setFieldValue(name, value);
                  }}
                  onFieldBlur={(name) => setFieldTouched(name, true)}
                  submitLabel={editingUser ? "Atualizar" : "Adicionar"}
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
                  Membros da Equipe
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
                  {
                    key: "role",
                    label: "Função",
                    render: (value) => value === "admin" ? "👑 Admin" : "👤 Usuário",
                  },
                ]}
                onEdit={handleEditUser}
                onDelete={handleDeleteUser}
                isLoading={loading}
                emptyMessage="Nenhum usuário encontrado"
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

export default Users;
