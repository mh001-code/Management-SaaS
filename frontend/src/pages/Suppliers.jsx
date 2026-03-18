import React, { useRef, useState } from "react";
import { useFetch, useSearch, useForm, usePagination } from "../hooks";
import api from "../services/api";
import errorService from "../services/errorService";
import notificationService from "../services/notificationService";
import DataTable from "../components/DataTable";
import DataForm from "../components/DataForm";
import PageShell from "../components/PageShell";
import Card from "../components/ui/Card";
import Pagination from "../components/Pagination";

const ICON_PATH = "M17 20h4v-2a4 4 0 0 0-4-4M9 20H5v-2a4 4 0 0 0 4-4m0 0a4 4 0 1 0 8 0 4 4 0 0 0-8 0M3 10h18M3 6h18M3 14h4M13 14h4";

const Suppliers = () => {
  const formRef = useRef(null);
  const [editing, setEditing] = useState(null);
  const [search, setSearch]   = useState("");

  const { data: suppliers, loading, error, refetch } = useFetch(
    "/suppliers", true, 5 * 60 * 1000
  );

  const filtered = (suppliers || []).filter((s) =>
    [s.name, s.email, s.document, s.contact_name].some((f) =>
      (f ?? "").toLowerCase().includes(search.toLowerCase())
    )
  );

  const { paginatedItems, currentPage, goToPage, totalPages } = usePagination(filtered, 10);

  const initialValues = {
    name:         editing?.name         ?? "",
    email:        editing?.email        ?? "",
    phone:        editing?.phone        ?? "",
    document:     editing?.document     ?? "",
    contact_name: editing?.contact_name ?? "",
    notes:        editing?.notes        ?? "",
  };

  const { values, errors, touched, isSubmitting, handleSubmit, resetForm,
          setFieldValue, setFieldTouched } =
    useForm(initialValues, async (data) => {
      try {
        if (editing) {
          await api.put(`/suppliers/${editing.id}`, data);
          notificationService.success("Fornecedor atualizado!");
        } else {
          await api.post("/suppliers", data);
          notificationService.success("Fornecedor criado!");
        }
        setEditing(null);
        resetForm();
        refetch();
      } catch (err) {
        notificationService.error(errorService.handle(err, "salvar fornecedor"));
      }
    });

  const handleEdit = (s) => {
    setEditing(s);
    Object.entries(s).forEach(([k, v]) => setFieldValue(k, v ?? ""));
    formRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
  };

  const handleDelete = async (id) => {
    try {
      await api.delete(`/suppliers/${id}`);
      notificationService.success("Fornecedor deletado!");
      refetch();
    } catch (err) {
      notificationService.error(errorService.handle(err, "deletar fornecedor"));
    }
  };

  return (
    <div className="main-content">
      <PageShell
        title="Fornecedores"
        count={loading ? null : filtered.length}
        icon={ICON_PATH}
        description="Gerencie fornecedores e ordens de compra"
        actions={
          <input
            className="input"
            placeholder="Buscar fornecedor..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{ width: 220 }}
          />
        }
      />

      <div className="page-body">
        {error && <div className="alert alert-danger">{error}</div>}

        <div ref={formRef}>
          <Card title={editing ? "✎ Editar fornecedor" : "+ Novo fornecedor"}>
            <DataForm
              fields={[
                { name: "name",         label: "Razão Social / Nome", type: "text",     placeholder: "Nome do fornecedor", required: true },
                { name: "document",     label: "CNPJ / CPF",          type: "text",     placeholder: "00.000.000/0000-00" },
                { name: "contact_name", label: "Responsável",         type: "text",     placeholder: "Nome do contato"    },
                { name: "email",        label: "E-mail",              type: "email",    placeholder: "email@empresa.com"  },
                { name: "phone",        label: "Telefone",            type: "text",     placeholder: "(11) 99999-0000"    },
                { name: "notes",        label: "Observações",         type: "textarea", placeholder: "Informações adicionais..." },
              ]}
              values={values}
              errors={errors}
              touched={touched}
              isSubmitting={isSubmitting}
              onSubmit={handleSubmit}
              onCancel={editing ? () => { setEditing(null); resetForm(); } : null}
              onFieldChange={(name, value) => setFieldValue(name, value)}
              onFieldBlur={(name) => setFieldTouched(name, true)}
              submitLabel={editing ? "Atualizar" : "Adicionar"}
            />
          </Card>
        </div>

        <div className="chart-card">
          <DataTable
            rows={paginatedItems}
            columns={[
              { key: "name",         label: "Nome" },
              { key: "document",     label: "CNPJ / CPF",
                render: (v) => v || <span style={{ color: "var(--color-textMuted)" }}>—</span> },
              { key: "contact_name", label: "Responsável",
                render: (v) => v || <span style={{ color: "var(--color-textMuted)" }}>—</span> },
              { key: "email",        label: "E-mail",
                render: (v) => v
                  ? <span style={{ color: "var(--color-textMuted)", fontSize: 12 }}>{v}</span>
                  : <span style={{ color: "var(--color-textMuted)" }}>—</span> },
              { key: "phone",        label: "Telefone",
                render: (v) => v || <span style={{ color: "var(--color-textMuted)" }}>—</span> },
            ]}
            onEdit={handleEdit}
            onDelete={handleDelete}
            isLoading={loading}
            emptyMessage="Nenhum fornecedor cadastrado ainda"
            emptyIcon="clients"
          />
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} />
        </div>
      </div>
    </div>
  );
};

export default Suppliers;
