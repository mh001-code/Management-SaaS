import React, { useState, useEffect } from "react";
import api from "../services/api";
import FormContainer from "./FormContainer";
import Button from "./ui/Button";
import Input from "./ui/Input";
import notificationService from "../services/notificationService";
import errorService from "../services/errorService";

const ClientForm = ({ editingClient, setEditingClient, fetchClients }) => {
  const [form, setForm] = useState({ name: "", email: "" });
  const [errors, setErrors] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    if (editingClient) {
      setForm({ name: editingClient.name, email: editingClient.email });
      setErrors({});
    } else {
      setForm({ name: "", email: "" });
    }
  }, [editingClient]);

  const validateForm = () => {
    const errs = {};
    if (!form.name) errs.name = "Nome é obrigatório";
    if (!form.email) errs.email = "Email é obrigatório";
    else if (!/\S+@\S+\.\S+/.test(form.email)) errs.email = "Email inválido";
    setErrors(errs);
    return Object.keys(errs).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) return;

    setIsSubmitting(true);
    try {
      if (editingClient) {
        await api.put(`/clients/${editingClient.id}`, form);
        notificationService.success("Cliente atualizado com sucesso!");
      } else {
        await api.post("/clients", form);
        notificationService.success("Cliente criado com sucesso!");
      }
      setForm({ name: "", email: "" });
      setEditingClient(null);
      fetchClients();
    } catch (err) {
      const message = errorService.handle(err, "salvar cliente");
      notificationService.error(message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleCancel = () => {
    setForm({ name: "", email: "" });
    setEditingClient(null);
    setErrors({});
  };

  return (
    <FormContainer editTarget={editingClient}>
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
            {editingClient ? "✏️ Editar Cliente" : "➕ Adicionar Cliente"}
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
            placeholder="Nome do cliente"
            value={form.name}
            onChange={(e) => setForm({ ...form, name: e.target.value })}
            disabled={isSubmitting}
            error={!!errors.name}
            errorMessage={errors.name}
          />

          <Input
            type="email"
            label="Email"
            required
            placeholder="exemplo@email.com"
            value={form.email}
            onChange={(e) => setForm({ ...form, email: e.target.value })}
            disabled={isSubmitting}
            error={!!errors.email}
            errorMessage={errors.email}
          />
        </div>

        {/* Botões de Ação */}
        <div style={{
          display: 'flex',
          gap: 'var(--space-md)',
          justifyContent: 'flex-end',
          flexWrap: 'wrap',
        }}>
          {editingClient && (
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
            variant={editingClient ? "warning" : "success"}
            disabled={isSubmitting}
          >
            {isSubmitting ? "Processando..." : (editingClient ? "✓ Atualizar" : "✓ Criar")}
          </Button>
        </div>
      </form>
    </FormContainer>
  );
};

export default ClientForm;