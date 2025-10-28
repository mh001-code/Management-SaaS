import React, { useState, useEffect } from "react";
import api from "../services/api";

const ClientForm = ({ editingClient, setEditingClient, fetchClients }) => {
  const [form, setForm] = useState({ name: "", email: "" });
  const [errors, setErrors] = useState({});

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

    try {
      if (editingClient) {
        await api.put(`/clients/${editingClient.id}`, form, {
          headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
        });
      } else {
        await api.post("/clients", form, {
          headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
        });
      }
      setForm({ name: "", email: "" });
      setEditingClient(null);
      fetchClients();
    } catch (err) {
      console.error(err);
    }
  };

  const handleCancel = () => {
    setForm({ name: "", email: "" });
    setEditingClient(null);
    setErrors({});
  };

  return (
    <form
      className="bg-white p-4 md:p-6 rounded shadow mb-6 grid grid-cols-1 sm:grid-cols-2 gap-4 w-full"
      onSubmit={handleSubmit}
    >
      <div className="flex flex-col">
        <label className="font-medium mb-1">Nome</label>
        <input
          type="text"
          value={form.name}
          onChange={(e) => setForm({ ...form, name: e.target.value })}
          className="border p-2 rounded focus:ring-2 focus:ring-blue-400 transition w-full"
        />
        {errors.name && (
          <p className="text-red-500 text-sm mt-1">{errors.name}</p>
        )}
      </div>

      <div className="flex flex-col">
        <label className="font-medium mb-1">Email</label>
        <input
          type="email"
          value={form.email}
          onChange={(e) => setForm({ ...form, email: e.target.value })}
          className="border p-2 rounded focus:ring-2 focus:ring-blue-400 transition w-full"
        />
        {errors.email && (
          <p className="text-red-500 text-sm mt-1">{errors.email}</p>
        )}
      </div>

      <div className="sm:col-span-2 flex flex-col sm:flex-row gap-2 justify-end">
        <button
          type="submit"
          className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition w-full sm:w-auto"
        >
          {editingClient ? "Atualizar" : "Adicionar"}
        </button>
        {editingClient && (
          <button
            type="button"
            onClick={handleCancel}
            className="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400 transition w-full sm:w-auto"
          >
            Cancelar
          </button>
        )}
      </div>
    </form>
  );
};

export default ClientForm;