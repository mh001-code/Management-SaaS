import React, { useState, useEffect } from "react";
import FormContainer from "./FormContainer";
import Button from "./ui/Button";
import Input from "./ui/Input";

const ProductForm = ({ productToEdit, onSave, onCancel }) => {
  const [form, setForm] = useState({ name: "", price: "", description: "", stock_quantity: "" });
  const [errors, setErrors] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    if (productToEdit) {
      setForm({
        name: productToEdit.name || "",
        price: productToEdit.price || "",
        description: productToEdit.description || "",
        stock_quantity: productToEdit.stock_quantity || "",
      });
      setErrors({});
    } else {
      setForm({ name: "", price: "", description: "", stock_quantity: "" });
    }
  }, [productToEdit]);

  const validateForm = () => {
    const errs = {};
    if (!form.name) errs.name = "Nome é obrigatório";
    if (!form.price && form.price !== 0) errs.price = "Preço é obrigatório";
    if (form.stock_quantity === "" || form.stock_quantity < 0) errs.stock_quantity = "Estoque inválido";
    setErrors(errs);
    return Object.keys(errs).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!validateForm()) return;
    setIsSubmitting(true);
    try {
      onSave({ ...form, price: Number(form.price), stock_quantity: Number(form.stock_quantity) });
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleCancel = () => {
    onCancel();
    setErrors({});
  };

  return (
    <FormContainer editTarget={productToEdit}>
      <form style={{ width: '100%' }} onSubmit={handleSubmit}>
        {/* Título */}
        <div style={{
          marginBottom: 'var(--space-xl)',
          paddingBottom: 'var(--space-lg)',
          borderBottom: '1px solid var(--color-border)',
        }}>
          <h3 style={{
            fontSize: 'var(--text-lg)',
            fontWeight: '700',
            color: 'var(--color-text)',
            margin: 0,
            fontFamily: 'var(--font-display)',
          }}>
            {productToEdit ? "✏️ Editar Produto" : "➕ Adicionar Produto"}
          </h3>
        </div>

        {/* Grid de formulário */}
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
          gap: 'var(--space-lg)',
          marginBottom: 'var(--space-2xl)',
        }}>
          <Input
            type="text"
            label="Nome"
            required
            placeholder="Nome do produto"
            value={form.name}
            onChange={(e) => setForm({ ...form, name: e.target.value })}
            disabled={isSubmitting}
            error={!!errors.name}
            errorMessage={errors.name}
          />

          <Input
            type="number"
            label="Preço"
            required
            placeholder="0,00"
            value={form.price}
            onChange={(e) => setForm({ ...form, price: e.target.value })}
            disabled={isSubmitting}
            error={!!errors.price}
            errorMessage={errors.price}
          />

          <Input
            type="number"
            label="Estoque"
            required
            placeholder="0"
            value={form.stock_quantity}
            onChange={(e) => setForm({ ...form, stock_quantity: e.target.value })}
            disabled={isSubmitting}
            error={!!errors.stock_quantity}
            errorMessage={errors.stock_quantity}
          />

          {/* Descrição - full width */}
          <div style={{
            gridColumn: '1 / -1',
          }}>
            <label style={{
              display: 'block',
              fontSize: 'var(--text-sm)',
              fontWeight: '600',
              color: 'var(--color-text)',
              marginBottom: 'var(--space-sm)',
              fontFamily: 'var(--font-body)',
            }}>
              Descrição
            </label>
            <textarea
              value={form.description}
              onChange={(e) => setForm({ ...form, description: e.target.value })}
              placeholder="Descrição do produto..."
              rows={4}
              disabled={isSubmitting}
              style={{
                width: '100%',
                padding: 'var(--space-md) var(--space-lg)',
                backgroundColor: 'var(--color-surface2)',
                border: '1px solid var(--color-border)',
                borderRadius: 'var(--radius-md)',
                color: 'var(--color-text)',
                fontFamily: 'var(--font-body)',
                fontSize: 'var(--text-base)',
                resize: 'vertical',
                transition: 'all 150ms ease',
              }}
            />
          </div>
        </div>

        {/* Botões de Ação */}
        <div style={{
          display: 'flex',
          gap: 'var(--space-md)',
          justifyContent: 'flex-end',
          flexWrap: 'wrap',
        }}>
          {productToEdit && (
            <Button
              type="button"
              onClick={handleCancel}
              variant="secondary"
              disabled={isSubmitting}
            >
              ✕ Cancelar
            </Button>
          )}
          <Button
            type="submit"
            variant={productToEdit ? "warning" : "success"}
            disabled={isSubmitting}
          >
            {isSubmitting ? "Processando..." : (productToEdit ? "✓ Atualizar" : "✓ Criar")}
          </Button>
        </div>
      </form>
    </FormContainer>
  );
};

export default ProductForm;