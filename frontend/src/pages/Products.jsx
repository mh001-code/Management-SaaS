import React, { useEffect, useRef, useState } from "react";
import { useFetch, useSearch, useForm, usePagination } from "../hooks";
import { API_ENDPOINTS } from "../constants";
import api from "../services/api";
import errorService from "../services/errorService";
import notificationService from "../services/notificationService";
import { useAuth } from "../contexts/AuthContext";
import DataTable from "../components/DataTable";
import DataForm from "../components/DataForm";
import Card from "../components/ui/Card";
import Input from "../components/ui/Input";
import Button from "../components/ui/Button";

const Products = () => {
  const { user, logout } = useAuth();
  const formRef = useRef(null);
  const [editingProduct, setEditingProduct] = useState(null);

  // Hooks customizados
  const { data: products, loading, error, refetch } = useFetch(
    API_ENDPOINTS.PRODUCTS,
    true,
    5 * 60 * 1000 // 5 minutos de cache
  );

  const { search, setSearch, filtered } = useSearch(products || [], [
    "name",
    "category",
  ]);

  const { paginatedItems, currentPage, goToPage, totalPages } = usePagination(
    filtered,
    10
  );

  const initialValues = {
    name: editingProduct?.name || "",
    category: editingProduct?.category || "",
    price: editingProduct?.price || "",
    stock_quantity: editingProduct?.stock_quantity || "",
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
    // Validação básica
    if (!formData.name || !formData.price) {
      notificationService.error("Nome e preço são obrigatórios");
      return;
    }

    try {
      const dataToSend = {
        ...formData,
        price: parseFloat(formData.price),
        stock_quantity: parseInt(formData.stock_quantity) || 0,
      };

      if (editingProduct) {
        await api.put(
          `${API_ENDPOINTS.PRODUCTS}/${editingProduct.id}`,
          dataToSend
        );
        notificationService.success("Produto atualizado com sucesso!");
      } else {
        await api.post(API_ENDPOINTS.PRODUCTS, dataToSend);
        notificationService.success("Produto criado com sucesso!");
      }

      setEditingProduct(null);
      resetForm();
      refetch();
    } catch (err) {
      const message = errorService.handle(
        err,
        "criação/atualização do produto"
      );
      notificationService.error(message);
    }
  });

  const handleEditProduct = (product) => {
    setEditingProduct(product);
    setFieldValue("name", product.name);
    setFieldValue("category", product.category || "");
    setFieldValue("price", product.price);
    setFieldValue("stock_quantity", product.stock_quantity);
    if (formRef.current) {
      formRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  };

  const handleDeleteProduct = async (id) => {
    try {
      await api.delete(`${API_ENDPOINTS.PRODUCTS}/${id}`);
      notificationService.success("Produto deletado com sucesso!");
      refetch();
    } catch (err) {
      const message = errorService.handle(err, "deleção do produto");
      notificationService.error(message);
    }
  };

  const handleCancel = () => {
    setEditingProduct(null);
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
    <div className="main-content">
          <div className="topbar">
            <div className="topbar-title">Produtos</div>
            <div className="topbar-right">
              <Input
                placeholder="🔍 Buscar produto..."
                value={search}
                onChange={(e) => setSearch(e.target.value)}
              />
            </div>
          </div>

          <div className="page-body">
            {/* Formulário */}
            <div ref={formRef} className="animate-fadeUp">
              <Card title={editingProduct ? "✏️ Editar Produto" : "➕ Novo Produto"}>
                <DataForm
                  fields={[
                    {
                      name: "name",
                      label: "Nome",
                      type: "text",
                      placeholder: "Digite o nome do produto",
                      required: true,
                    },
                    {
                      name: "category",
                      label: "Categoria",
                      type: "text",
                      placeholder: "Digite a categoria",
                    },
                    {
                      name: "price",
                      label: "Preço (R$)",
                      type: "number",
                      placeholder: "0.00",
                      required: true,
                    },
                    {
                      name: "stock_quantity",
                      label: "Estoque",
                      type: "number",
                      placeholder: "0",
                    },
                  ]}
                  values={values}
                  errors={errors}
                  touched={touched}
                  isSubmitting={isSubmitting}
                  onSubmit={formSubmit}
                  onCancel={editingProduct ? handleCancel : null}
                  onFieldChange={(name, value) => {
                    setFieldValue(name, value);
                  }}
                  onFieldBlur={(name) => setFieldTouched(name, true)}
                  submitLabel={editingProduct ? "Atualizar" : "Adicionar"}
                />
              </Card>
            </div>

            {/* Tabela */}
            <div className="chart-card animate-fadeUp">
              <div
                style={{
                  display: "flex",
                  justifyContent: "space-between",
                  alignItems: "center",
                  marginBottom: 16,
                }}
              >
                <div className="chart-title" style={{ marginBottom: 0 }}>
                  Catálogo de Produtos
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
                  { key: "category", label: "Categoria" },
                  {
                    key: "price",
                    label: "Preço",
                    render: (value) => `R$ ${Number(value).toFixed(2)}`,
                  },
                  { key: "stock_quantity", label: "Estoque" },
                ]}
                onEdit={handleEditProduct}
                onDelete={handleDeleteProduct}
                isLoading={loading}
                emptyMessage="Nenhum produto encontrado"
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
  );
};

export default Products;
