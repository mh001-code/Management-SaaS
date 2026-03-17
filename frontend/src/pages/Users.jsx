import React, { useRef, useState } from "react";
import { useFetch, useSearch, useForm, usePagination } from "../hooks";
import { API_ENDPOINTS, USER_ROLES } from "../constants";
import api from "../services/api";
import errorService from "../services/errorService";
import notificationService from "../services/notificationService";
import { useAuth } from "../contexts/AuthContext";
import DataTable from "../components/DataTable";
import DataForm from "../components/DataForm";
import Pagination from "../components/Pagination";
import Card from "../components/ui/Card";
import Input from "../components/ui/Input";

const Users = () => {
  const { user } = useAuth();
  const formRef = useRef(null);
  const [editingUser, setEditingUser] = useState(null);

  const isAdmin = user?.role === USER_ROLES.ADMIN;

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
        await api.put(`${API_ENDPOINTS.USERS}/${editingUser.id}`, formData);
        notificationService.success("Usuário atualizado com sucesso!");
      } else {
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

  if (!isAdmin && !loading) {
    return (
      <div style={{ padding: "20px", textAlign: "center" }}>
        <div style={{ padding: "40px", textAlign: "center", color: "rgba(255,255,255,0.5)" }}>
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
    <div className="main-content">
      <div className="topbar">
        <div className="topbar-title">Usuários</div>
        <div className="topbar-right">
          <Input
            placeholder="🔍 Buscar usuário..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      <div className="page-body">
        {/* Formulário */}
        <div ref={formRef} className="animate-fadeUp">
          <Card title={editingUser ? "✏️ Editar Usuário" : "➕ Novo Usuário"}>
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
              onFieldChange={(name, value) => setFieldValue(name, value)}
              onFieldBlur={(name) => setFieldTouched(name, true)}
              submitLabel={editingUser ? "Atualizar" : "Adicionar"}
            />
          </Card>
        </div>

        {/* Tabela */}
        <div className="chart-card animate-fadeUp">
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
            <div className="chart-title" style={{ marginBottom: 0 }}>
              Membros da Equipe
              <span className="badge badge-blue" style={{ marginLeft: 10 }}>
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

export default Users;