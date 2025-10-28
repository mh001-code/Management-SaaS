import React, { useState, useEffect } from "react";

const ProductForm = ({ productToEdit, onSave, onCancel }) => {
  const [form, setForm] = useState({ name: "", price: "", description: "", stock_quantity: "" });
  const [errors, setErrors] = useState({});

  useEffect(() => {
    if (productToEdit) {
      setForm({
        name: productToEdit.name || "",
        price: productToEdit.price || "",
        description: productToEdit.description || "",
        stock_quantity: productToEdit.stock_quantity || ""
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
    onSave({ ...form, price: Number(form.price), stock_quantity: Number(form.stock_quantity) });
  };

  const handleCancel = () => {
    onCancel();
    setErrors({});
  };

  return (
    <form
      onSubmit={handleSubmit}
      className="mb-6 p-4 md:p-6 bg-white rounded shadow grid grid-cols-1 sm:grid-cols-2 gap-4"
    >
      <h2 className="text-lg font-semibold sm:col-span-2">
        {productToEdit ? "Editar Produto" : "Adicionar Produto"}
      </h2>

      <div className="flex flex-col">
        <label className="font-medium mb-1">Nome</label>
        <input
          type="text"
          value={form.name}
          onChange={(e) => setForm({ ...form, name: e.target.value })}
          className="border p-2 rounded w-full"
        />
        {errors.name && <p className="text-red-500 text-sm mt-1">{errors.name}</p>}
      </div>

      <div className="flex flex-col">
        <label className="font-medium mb-1">Preço</label>
        <input
          type="number"
          value={form.price}
          onChange={(e) => setForm({ ...form, price: e.target.value })}
          className="border p-2 rounded w-full"
        />
        {errors.price && <p className="text-red-500 text-sm mt-1">{errors.price}</p>}
      </div>

      <div className="flex flex-col">
        <label className="font-medium mb-1">Estoque</label>
        <input
          type="number"
          value={form.stock_quantity}
          onChange={(e) => setForm({ ...form, stock_quantity: e.target.value })}
          className="border p-2 rounded w-full"
        />
        {errors.stock_quantity && <p className="text-red-500 text-sm mt-1">{errors.stock_quantity}</p>}
      </div>

      <div className="flex flex-col sm:col-span-2">
        <label className="font-medium mb-1">Descrição</label>
        <textarea
          value={form.description}
          onChange={(e) => setForm({ ...form, description: e.target.value })}
          className="border p-2 rounded w-full"
        />
      </div>

      <div className="sm:col-span-2 flex flex-col sm:flex-row gap-2 justify-end">
        <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 w-full sm:w-auto">
          {productToEdit ? "Atualizar" : "Criar"}
        </button>
        {productToEdit && (
          <button
            type="button"
            onClick={handleCancel}
            className="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400 w-full sm:w-auto"
          >
            Cancelar
          </button>
        )}
      </div>
    </form>
  );
};

export default ProductForm;