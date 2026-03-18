import React, { useRef, useState } from "react";
import { useFetch, useSearch, useForm, usePagination } from "../hooks";
import { API_ENDPOINTS, USER_ROLES } from "../constants";
import api from "../services/api";
import errorService from "../services/errorService";
import notificationService from "../services/notificationService";
import { useAuth } from "../contexts/AuthContext";
import DataTable from "../components/DataTable";
import DataForm from "../components/DataForm";
import PageShell from "../components/PageShell";
import Card from "../components/ui/Card";
import Pagination from "../components/Pagination";

const ICON_PATH = "M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z";

const AVATAR_COLORS = ["#7C6AF7","#00D4AA","#F7916A","#F76464","#85B7EB"];

const RoleBadge = ({ role }) => (
  <span style={{
    display: "inline-flex", alignItems: "center", gap: 5,
    padding: "3px 9px", borderRadius: 99,
    background: role === "admin" ? "rgba(124,106,247,0.12)" : "rgba(122,122,154,0.12)",
    color: role === "admin" ? "var(--color-primary)" : "var(--color-textMuted)",
    fontSize: 11, fontWeight: 600,
  }}>
    {role === "admin" ? "★ Admin" : "Usuário"}
  </span>
);

const UserAvatar = ({ email, index }) => {
  const initials = email ? email[0].toUpperCase() : "U";
  const color = AVATAR_COLORS[index % AVATAR_COLORS.length];
  return (
    <div style={{
      width: 28, height: 28, borderRadius: 8,
      background: color + "22", color,
      display: "inline-flex", alignItems: "center", justifyContent: "center",
      fontSize: 11, fontWeight: 700, flexShrink: 0,
      marginRight: 8, verticalAlign: "middle",
    }}>
      {initials}
    </div>
  );
};

const Users = () => {
  const { user } = useAuth();
  const formRef = useRef(null);
  const [editingUser, setEditingUser] = useState(null);
  const isAdmin = user?.role === USER_ROLES.ADMIN;

  const { data: users, loading, error, refetch } = useFetch(
    isAdmin ? API_ENDPOINTS.USERS : null, isAdmin, 5 * 60 * 1000
  );

  const { search, setSearch, filtered } = useSearch(users || [], ["name", "email"]);

  const { paginatedItems, currentPage, goToPage, totalPages } = usePagination(filtered, 10);

  const initialValues = {
    name:  editingUser?.name  ?? "",
    email: editingUser?.email ?? "",
    role:  editingUser?.role  ?? "user",
  };

  const { values, errors, touched, isSubmitting, handleSubmit, resetForm, setFieldValue, setFieldTouched } =
    useForm(initialValues, async (data) => {
      try {
        if (editingUser) {
          await api.put(`${API_ENDPOINTS.USERS}/${editingUser.id}`, data);
          notificationService.success("Usuário atualizado!");
        } else {
          if (!data.password) { notificationService.error("Senha obrigatória"); return; }
          await api.post(API_ENDPOINTS.USERS, data);
          notificationService.success("Usuário criado!");
        }
        setEditingUser(null);
        resetForm();
        refetch();
      } catch (err) {
        notificationService.error(errorService.handle(err, "salvar usuário"));
      }
    });

  const handleEdit = (u) => {
    setEditingUser(u);
    setFieldValue("name",  u.name);
    setFieldValue("email", u.email);
    setFieldValue("role",  u.role ?? "user");
    formRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
  };

  const handleDelete = async (id) => {
    try {
      await api.delete(`${API_ENDPOINTS.USERS}/${id}`);
      notificationService.success("Usuário deletado!");
      refetch();
    } catch (err) {
      notificationService.error(errorService.handle(err, "deletar usuário"));
    }
  };

  if (!isAdmin && !loading) {
    return (
      <div className="main-content">
        <div style={{
          display: "flex", flexDirection: "column", alignItems: "center",
          justifyContent: "center", minHeight: "60vh", gap: 12,
          color: "var(--color-textMuted)",
        }}>
          <svg width="48" height="48" viewBox="0 0 48 48" fill="none" style={{ opacity: .4 }}>
            <rect x="6" y="20" width="36" height="24" rx="4" stroke="currentColor" strokeWidth="1.5"/>
            <path d="M14 20v-6a10 10 0 0 1 20 0v6" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
            <circle cx="24" cy="32" r="3" fill="currentColor" opacity=".5"/>
          </svg>
          <p style={{ fontSize: 15, fontWeight: 600 }}>Acesso restrito</p>
          <p style={{ fontSize: 13 }}>Apenas administradores podem gerenciar usuários.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="main-content">
      <PageShell
        title="Usuários"
        count={loading ? null : filtered.length}
        icon={ICON_PATH}
        description="Membros e permissões do sistema"
        actions={
          <input
            className="input"
            placeholder="Buscar usuário..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{ width: 220 }}
          />
        }
      />

      <div className="page-body">
        {error && <div className="alert alert-danger">{error}</div>}

        <div ref={formRef}>
          <Card title={editingUser ? "✎ Editar usuário" : "+ Novo usuário"}>
            <DataForm
              fields={[
                { name: "name",  label: "Nome",  type: "text",  placeholder: "Nome completo",    required: true },
                { name: "email", label: "Email", type: "email", placeholder: "email@exemplo.com", required: true },
                { name: "role",  label: "Função",type: "select",
                  options: [{ value: "user", label: "Usuário" }, { value: "admin", label: "Admin" }],
                  required: true },
                ...(!editingUser ? [{
                  name: "password", label: "Senha", type: "password",
                  placeholder: "Mínimo 6 caracteres", required: true,
                }] : []),
              ]}
              values={values}
              errors={errors}
              touched={touched}
              isSubmitting={isSubmitting}
              onSubmit={handleSubmit}
              onCancel={editingUser ? () => { setEditingUser(null); resetForm(); } : null}
              onFieldChange={(name, value) => setFieldValue(name, value)}
              onFieldBlur={(name) => setFieldTouched(name, true)}
              submitLabel={editingUser ? "Atualizar" : "Adicionar"}
            />
          </Card>
        </div>

        <div className="chart-card">
          <DataTable
            rows={paginatedItems}
            columns={[
              { key: "name",       label: "Nome",
                render: (v, row) => (
                  <span style={{ display: "inline-flex", alignItems: "center" }}>
                    <UserAvatar email={row.email} index={row.id ?? 0} />
                    {v}
                  </span>
                )},
              { key: "email",      label: "Email",
                render: (v) => <span style={{ color: "var(--color-textMuted)", fontSize: 12 }}>{v}</span> },
              { key: "role",       label: "Função",
                render: (v) => <RoleBadge role={v} /> },
              { key: "created_at", label: "Desde",
                render: (v) => v ? new Date(v).toLocaleDateString("pt-BR") : "—" },
            ]}
            onEdit={handleEdit}
            onDelete={handleDelete}
            isLoading={loading}
            emptyMessage="Nenhum usuário encontrado"
            emptyIcon="users"
          />
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} />
        </div>
      </div>
    </div>
  );
};

export default Users;
