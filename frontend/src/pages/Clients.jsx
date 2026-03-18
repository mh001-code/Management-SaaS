import React, { useRef, useState } from "react";
import { useFetch, useForm, usePagination } from "../hooks";
import { API_ENDPOINTS } from "../constants";
import api from "../services/api";
import errorService from "../services/errorService";
import notificationService from "../services/notificationService";
import DataTable from "../components/DataTable";
import DataForm from "../components/DataForm";
import PageShell from "../components/PageShell";
import Card from "../components/ui/Card";
import Pagination from "../components/Pagination";

const ICON_PATH = "M10 9a4 4 0 1 0 0-8 4 4 0 0 0 0 8zm-7 9a7 7 0 0 1 14 0";

const Clients = () => {
  const formRef = useRef(null);
  const [editingClient, setEditingClient] = useState(null);
  const [search, setSearch] = useState("");

  const { data: clients, loading, error, refetch } = useFetch(
    API_ENDPOINTS.CLIENTS, true, 5 * 60 * 1000
  );

  const filtered = (clients || []).filter((c) =>
    [c.name, c.email, c.phone, c.address].some((f) =>
      (f ?? "").toLowerCase().includes(search.toLowerCase())
    )
  );

  const { paginatedItems, currentPage, goToPage, totalPages } = usePagination(filtered, 10);

  const initialValues = {
    name:    editingClient?.name    ?? "",
    email:   editingClient?.email   ?? "",
    phone:   editingClient?.phone   ?? "",
    address: editingClient?.address ?? "",
  };

  const { values, errors, touched, isSubmitting, handleSubmit, resetForm,
          setFieldValue, setFieldTouched } =
    useForm(initialValues, async (data) => {
      try {
        if (editingClient) {
          await api.put(`${API_ENDPOINTS.CLIENTS}/${editingClient.id}`, data);
          notificationService.success("Cliente atualizado com sucesso!");
        } else {
          await api.post(API_ENDPOINTS.CLIENTS, data);
          notificationService.success("Cliente criado com sucesso!");
        }
        setEditingClient(null);
        resetForm();
        refetch();
      } catch (err) {
        notificationService.error(errorService.handle(err, "salvar cliente"));
      }
    });

  const handleEdit = (client) => {
    setEditingClient(client);
    setFieldValue("name",    client.name    ?? "");
    setFieldValue("email",   client.email   ?? "");
    setFieldValue("phone",   client.phone   ?? "");
    setFieldValue("address", client.address ?? "");
    formRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
  };

  const handleDelete = async (id) => {
    try {
      await api.delete(`${API_ENDPOINTS.CLIENTS}/${id}`);
      notificationService.success("Cliente deletado com sucesso!");
      refetch();
    } catch (err) {
      notificationService.error(errorService.handle(err, "deletar cliente"));
    }
  };

  const handleCancel = () => { setEditingClient(null); resetForm(); };

  return (
    <div className="main-content">
      <PageShell
        title="Clientes"
        count={loading ? null : filtered.length}
        icon={ICON_PATH}
        description="Gerencie sua base de clientes"
        actions={
          <input
            className="input"
            placeholder="Buscar cliente..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{ width: 220 }}
          />
        }
      />

      <div className="page-body">
        {error && <div className="alert alert-danger">{error}</div>}

        <div ref={formRef}>
          <Card title={editingClient ? "✎ Editar cliente" : "+ Novo cliente"}>
            <DataForm
              fields={[
                {
                  name: "name",
                  label: "Nome",
                  type: "text",
                  placeholder: "Nome completo",
                  required: true,
                },
                {
                  name: "email",
                  label: "Email",
                  type: "email",
                  placeholder: "email@exemplo.com",
                },
                {
                  name: "phone",
                  label: "Telefone",
                  type: "text",
                  placeholder: "(11) 99999-0000",
                },
                {
                  name: "address",
                  label: "Endereço",
                  type: "textarea",
                  placeholder: "Rua, número, bairro, cidade — UF",
                },
              ]}
              values={values}
              errors={errors}
              touched={touched}
              isSubmitting={isSubmitting}
              onSubmit={handleSubmit}
              onCancel={editingClient ? handleCancel : null}
              onFieldChange={(name, value) => setFieldValue(name, value)}
              onFieldBlur={(name) => setFieldTouched(name, true)}
              submitLabel={editingClient ? "Atualizar" : "Adicionar"}
            />
          </Card>
        </div>

        <div className="chart-card">
          <DataTable
            rows={paginatedItems}
            columns={[
              { key: "name",  label: "Nome" },
              { key: "email", label: "Email",
                render: (v) => v
                  ? <span style={{ color: "var(--color-textMuted)", fontSize: 12 }}>{v}</span>
                  : <span style={{ color: "var(--color-textMuted)" }}>—</span> },
              { key: "phone", label: "Telefone",
                render: (v) => v || <span style={{ color: "var(--color-textMuted)" }}>—</span> },
              { key: "address", label: "Endereço",
                render: (v) => v
                  ? <span style={{ color: "var(--color-textMuted)", fontSize: 12 }}>
                      {String(v).length > 45 ? String(v).slice(0, 45) + "…" : v}
                    </span>
                  : <span style={{ color: "var(--color-textMuted)" }}>—</span> },
              { key: "created_at", label: "Cadastro",
                render: (v) => v ? new Date(v).toLocaleDateString("pt-BR") : "—" },
            ]}
            onEdit={handleEdit}
            onDelete={handleDelete}
            isLoading={loading}
            emptyMessage="Nenhum cliente cadastrado ainda"
            emptyIcon="clients"
          />
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} />
        </div>
      </div>
    </div>
  );
};

export default Clients;
