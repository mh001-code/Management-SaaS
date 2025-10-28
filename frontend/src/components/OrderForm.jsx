import React, { useEffect, useState } from "react";
import api from "../services/api";

const OrderForm = ({ onOrderCreated }) => {
  const [clients, setClients] = useState([]);
  const [products, setProducts] = useState([]);
  const [items, setItems] = useState([]);
  const [selectedClientId, setSelectedClientId] = useState("");
  const [selectedProduct, setSelectedProduct] = useState("");
  const [quantity, setQuantity] = useState(1);

  useEffect(() => {
    const fetchClients = async () => {
      const res = await api.get("/clients", {
        headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
      });
      setClients(res.data);
    };
    const fetchProducts = async () => {
      const res = await api.get("/products", {
        headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
      });
      setProducts(res.data);
    };

    fetchClients();
    fetchProducts();
  }, []);

  const handleAddItem = () => {
    if (!selectedProduct || quantity <= 0) return;
    const product = products.find((p) => p.id === Number(selectedProduct));
    setItems((prev) => [
      ...prev,
      {
        product_id: product.id,
        name: product.name,
        quantity: Number(quantity),
        price: Number(product.price),
      },
    ]);
    setSelectedProduct("");
    setQuantity(1);
  };

  const handleRemoveItem = (index) => {
    setItems((prev) => prev.filter((_, i) => i !== index));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!selectedClientId || !items.length)
      return alert("Cliente e itens são obrigatórios");

    try {
      const res = await api.post(
        "/orders",
        { client_id: Number(selectedClientId), items },
        { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } }
      );
      onOrderCreated(res.data);
      setItems([]);
      setSelectedClientId("");
    } catch (err) {
      console.error("Erro ao criar pedido:", err);
    }
  };

  return (
    <form
      onSubmit={handleSubmit}
      className="p-4 bg-white rounded shadow space-y-4 mb-6"
    >
      <h2 className="text-lg font-semibold">{onOrderCreated ? "Lançar Pedido" : "Alterar Pedido"}</h2>
      {/* Seleção do Cliente */}
      <div>
        <label className="block font-medium mb-1">Cliente</label>
        <select
          value={selectedClientId}
          onChange={(e) => setSelectedClientId(e.target.value)}
          className="w-full p-2 border rounded"
          required
        >
          <option value="">Selecione</option>
          {clients.map((c) => (
            <option key={c.id} value={c.id}>
              {c.name}
            </option>
          ))}
        </select>
      </div>

      {/* Seleção de Produto */}
      <div className="flex flex-col md:flex-row gap-2 items-end">
        <div className="flex-1">
          <label className="block font-medium mb-1">Produto</label>
          <select
            value={selectedProduct}
            onChange={(e) => setSelectedProduct(e.target.value)}
            className="w-full p-2 border rounded"
          >
            <option value="">Selecione</option>
            {products.map((p) => (
              <option key={p.id} value={p.id}>
                {p.name} - R${Number(p.price).toFixed(2)}
              </option>
            ))}
          </select>
        </div>

        <div className="w-24">
          <label className="block font-medium mb-1">Qtd</label>
          <input
            type="number"
            min="1"
            value={quantity}
            onChange={(e) => setQuantity(Number(e.target.value))}
            className="w-full p-2 border rounded"
          />
        </div>

        <button
          type="button"
          onClick={handleAddItem}
          className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition"
        >
          Adicionar
        </button>
      </div>

      {/* Tabela de itens */}
      {items.length > 0 && (
        <table className="w-full border-collapse border mt-4">
          <thead className="bg-gray-100">
            <tr>
              <th className="px-4 py-2">Produto</th>
              <th className="px-4 py-2">Qtd</th>
              <th className="px-4 py-2">Preço</th>
              <th className="px-4 py-2">Total</th>
              <th className="px-4 py-2">Remover</th>
            </tr>
          </thead>
          <tbody>
            {items.map((item, i) => (
              <tr key={i} className="border-b hover:bg-gray-50">
                <td className="px-4 py-2">{item.name}</td>
                <td className="px-4 py-2">{item.quantity}</td>
                <td className="px-4 py-2">R${item.price.toFixed(2)}</td>
                <td className="px-4 py-2">
                  R${(item.price * item.quantity).toFixed(2)}
                </td>
                <td className="px-4 py-2">
                  <button
                    type="button"
                    onClick={() => handleRemoveItem(i)}
                    className="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600 transition"
                  >
                    X
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      <button
        type="submit"
        className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 transition"
      >
        Criar Pedido
      </button>
    </form>
  );
};

export default OrderForm;