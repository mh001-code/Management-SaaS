import React, { useRef, useState } from "react";
import { useFetch, useForm, usePagination } from "../hooks";
import { API_ENDPOINTS } from "../constants";
import api from "../services/api";
import errorService from "../services/errorService";
import notificationService from "../services/notificationService";
import { formatCurrency } from "../utils/formatCurrency";
import DataTable from "../components/DataTable";
import DataForm from "../components/DataForm";
import PageShell from "../components/PageShell";
import Card from "../components/ui/Card";
import Pagination from "../components/Pagination";

const ICON_PATH = "M3 3h14v4H3zM3 10h14v7H3z";

const StockBadge = ({ qty }) => {
  const n = Number(qty);
  const style =
    n === 0  ? { bg: "rgba(247,100,100,0.1)",   text: "#F76464" } :
    n <= 5   ? { bg: "rgba(247,145,106,0.1)",   text: "#F7916A" } :
               { bg: "rgba(0,212,170,0.1)",     text: "#00D4AA" };
  return (
    <span style={{
      display: "inline-flex", alignItems: "center", gap: 4,
      padding: "3px 9px", borderRadius: 99,
      background: style.bg, color: style.text,
      fontSize: 12, fontWeight: 600,
    }}>
      {n === 0 ? "Sem estoque" : `${n} un.`}
    </span>
  );
};

const Products = () => {
  const formRef = useRef(null);
  const [editingProduct, setEditingProduct] = useState(null);
  const [search, setSearch] = useState("");

  const { data: products, loading, error, refetch } = useFetch(
    API_ENDPOINTS.PRODUCTS, true, 5 * 60 * 1000
  );

  const filtered = (products || []).filter((p) =>
    (p.name ?? "").toLowerCase().includes(search.toLowerCase())
  );

  const { paginatedItems, currentPage, goToPage, totalPages } = usePagination(filtered, 10);

  const initialValues = {
    name: editingProduct?.name ?? "",
    price: editingProduct?.price ?? "",
    stock_quantity: editingProduct?.stock_quantity ?? "",
    description: editingProduct?.description ?? "",
  };

  const { values, errors, touched, isSubmitting, handleSubmit, resetForm, setFieldValue, setFieldTouched } =
    useForm(initialValues, async (data) => {
      if (!data.name || !data.price) {
        notificationService.error("Nome e preço são obrigatórios"); return;
      }
      try {
        const payload = {
          ...data,
          price: parseFloat(data.price),
          stock_quantity: parseInt(data.stock_quantity) || 0,
        };
        if (editingProduct) {
          await api.put(`${API_ENDPOINTS.PRODUCTS}/${editingProduct.id}`, payload);
          notificationService.success("Produto atualizado!");
        } else {
          await api.post(API_ENDPOINTS.PRODUCTS, payload);
          notificationService.success("Produto criado!");
        }
        setEditingProduct(null);
        resetForm();
        refetch();
      } catch (err) {
        notificationService.error(errorService.handle(err, "salvar produto"));
      }
    });

  const handleEdit = (product) => {
    setEditingProduct(product);
    setFieldValue("name", product.name);
    setFieldValue("price", product.price);
    setFieldValue("stock_quantity", product.stock_quantity);
    setFieldValue("description", product.description ?? "");
    formRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
  };

  const handleDelete = async (id) => {
    try {
      await api.delete(`${API_ENDPOINTS.PRODUCTS}/${id}`);
      notificationService.success("Produto deletado!");
      refetch();
    } catch (err) {
      notificationService.error(errorService.handle(err, "deletar produto"));
    }
  };

  const handleCancel = () => { setEditingProduct(null); resetForm(); };

  return (
    <div className="main-content">
      <PageShell
        title="Produtos"
        count={loading ? null : filtered.length}
        icon={ICON_PATH}
        description="Catálogo e controle de estoque"
        actions={
          <input
            className="input"
            placeholder="Buscar produto..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{ width: 220 }}
          />
        }
      />

      <div className="page-body">
        {error && <div className="alert alert-danger">{error}</div>}

        <div ref={formRef}>
          <Card title={editingProduct ? "✎ Editar produto" : "+ Novo produto"}>
            <DataForm
              fields={[
                { name: "name",          label: "Nome",     type: "text",   placeholder: "Nome do produto",  required: true },
                { name: "price",         label: "Preço",    type: "number", placeholder: "0,00",              required: true },
                { name: "stock_quantity",label: "Estoque",  type: "number", placeholder: "0" },
                { name: "description",   label: "Descrição",type: "textarea",placeholder: "Descrição opcional..." },
              ]}
              values={values}
              errors={errors}
              touched={touched}
              isSubmitting={isSubmitting}
              onSubmit={handleSubmit}
              onCancel={editingProduct ? handleCancel : null}
              onFieldChange={(name, value) => setFieldValue(name, value)}
              onFieldBlur={(name) => setFieldTouched(name, true)}
              submitLabel={editingProduct ? "Atualizar" : "Adicionar"}
            />
          </Card>
        </div>

        <div className="chart-card">
          <DataTable
            rows={paginatedItems}
            columns={[
              { key: "name",           label: "Nome" },
              { key: "price",          label: "Preço",
                render: (v) => <span style={{ fontFamily: "var(--font-mono)", fontWeight: 600 }}>{formatCurrency(v)}</span> },
              { key: "stock_quantity", label: "Estoque",
                render: (v) => <StockBadge qty={v} /> },
              { key: "description",    label: "Descrição",
                render: (v) => v
                  ? <span style={{ color: "var(--color-textMuted)", fontSize: 12 }}>{String(v).slice(0, 60)}{String(v).length > 60 ? "…" : ""}</span>
                  : <span style={{ color: "var(--color-textMuted)" }}>—</span> },
            ]}
            onEdit={handleEdit}
            onDelete={handleDelete}
            isLoading={loading}
            emptyMessage="Nenhum produto cadastrado ainda"
            emptyIcon="products"
          />
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} />
        </div>
      </div>
    </div>
  );
};

export default Products;
