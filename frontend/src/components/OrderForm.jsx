import React, { useEffect, useState } from "react";
import FormContainer from "./FormContainer";
import api from "../services/api";

const OrderForm = ({ onOrderCreated, editingOrder, onCancel }) => {
  const [clients, setClients] = useState([]);
  const [products, setProducts] = useState([]);
  const [items, setItems] = useState([]);
  const [selectedClientId, setSelectedClientId] = useState("");
  const [selectedProduct, setSelectedProduct] = useState("");
  const [quantity, setQuantity] = useState(1);
  const [status, setStatus] = useState("pendente");

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

  useEffect(() => {
    if (editingOrder) {
      setSelectedClientId(editingOrder.client_id);
      setStatus(editingOrder.status); // ✅ carrega o status
      setItems(editingOrder.items.map(it => ({ ...it, reserved_quantity: it.quantity })));
    } else {
      setSelectedClientId("");
      setStatus("pendente"); // ✅ quando criar novo volta para pendente
      setItems([]);
    }
  }, [editingOrder]);

  const handleAddItem = () => {
    if (!selectedProduct || quantity <= 0) return;

    const product = products.find((p) => p.id === Number(selectedProduct));
    if (!product) return;

    const existingItem = items.find((it) => it.product_id === product.id);
    const alreadyInOrder = existingItem ? existingItem.quantity : 0;

    const available = product.stock_quantity ?? product.stock ?? 0; // adapte ao nome que seu backend usa
    const totalRequested = alreadyInOrder + Number(quantity);

    // se o item já está no pedido atual (editingOrder), permitir até product.stock + existing
    const allowed = available + (existingItem ? existingItem.quantity : 0);

    if (totalRequested > allowed) {
      alert(`Estoque insuficiente! Disponível: ${allowed}, solicitado total: ${totalRequested}`);
      return;
    }

    // ✅ Se não exceder, adiciona normalmente:
    setItems((prev) => {
      if (existingItem) {
        return prev.map((it) =>
          it.product_id === product.id
            ? { ...it, quantity: totalRequested }
            : it
        );
      }
      return [
        ...prev,
        {
          product_id: product.id,
          quantity: Number(quantity),
          price: Number(product.price),
        },
      ];
    });

    setSelectedProduct("");
    setQuantity(1);
  };

  const handleRemoveItem = (index) => {
    setItems((prev) => prev.filter((_, i) => i !== index));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!selectedClientId || !items.length) return alert("Cliente e itens são obrigatórios");

    try {
      if (editingOrder) {
        await api.put(
          `/orders/${editingOrder.order_id}`,
          { client_id: Number(selectedClientId), items, status },   // ← AQUI
          { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } }
        );
        onCancel();
      } else {
        await api.post(
          "/orders",
          { client_id: Number(selectedClientId), items, status },   // ← AQUI
          { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } }
        );
      }
      setItems([]);
      setSelectedClientId("");
      onOrderCreated();
    } catch (err) {
      console.error("Erro ao salvar pedido:", err);
    }
  };

  return (
    <FormContainer editTarget={editingOrder}>
      <form className="grid grid-cols-1 sm:grid-cols-2 gap-4 w-full" onSubmit={handleSubmit}>
        <h2 className="text-lg font-semibold sm:col-span-2">
          {editingOrder ? "Alterar Pedido" : "Lançar Pedido"}
        </h2>

        <div className="flex flex-col sm:col-span-2">
          <label className="font-medium mb-1">Cliente</label>
          <select
            value={selectedClientId}
            onChange={(e) => setSelectedClientId(e.target.value)}
            className="w-full p-2 border rounded"
            required
          >
            <option value="">Selecione um cliente</option>
            {clients.map((c) => (
              <option key={c.id} value={c.id}>
                {c.name}
              </option>
            ))}
          </select>
        </div>

        <div className="flex flex-col sm:col-span-2">
          <label className="font-medium mb-1">Status</label>
          <select
            value={status}
            onChange={(e) => setStatus(e.target.value)}
            className="w-full p-2 border rounded"
          >
            <option value="pendente">Pendente</option>
            <option value="pago">Pago</option>
            <option value="enviado">Enviado</option>
            <option value="concluído">Concluído</option>
            <option value="cancelado">Cancelado</option>
          </select>
        </div>

        <div className="flex flex-col md:flex-row gap-2 sm:col-span-2 items-end">
          <div className="flex-1">
            <label className="font-medium mb-1">Produto</label>
            <select
              value={selectedProduct}
              onChange={(e) => setSelectedProduct(e.target.value)}
              className="w-full p-2 border rounded font-medium"
            >
              <option value="" className="text-gray-500 font-normal">
                Selecione um produto
              </option>

              {products.map((p) => (
                <option
                  key={p.id}
                  value={p.id}
                  className={`
        font-semibold
        ${p.stock_quantity <= 0 ? "text-red-500" : ""}
        ${p.stock_quantity > 0 && p.stock_quantity <= 5 ? "text-yellow-600" : ""}
        ${p.stock_quantity > 5 ? "text-green-700" : ""}
      `}
                  disabled={p.stock_quantity <= 0} // opcional
                >
                  {p.name} —
                  Estoque: {p.stock_quantity} | R${Number(p.price).toFixed(2)}
                </option>
              ))}
            </select>
          </div>

          <div className="w-24">
            <label className="font-medium mb-1">Qtd</label>
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

        {items.length > 0 && (
          <div className="sm:col-span-2 overflow-x-auto">
            <table className="w-full border-collapse border mt-4 bg-white">
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
                    <td className="px-4 py-2">{products.find(p => p.id === item.product_id)?.name || "—"}</td>
                    <td className="px-4 py-2">
                      <input
                        type="number"
                        min="1"
                        value={item.quantity}
                        onChange={(e) => {
                          const newQty = Number(e.target.value);
                          const product = products.find((p) => p.id === item.product_id);

                          if (!product) return;

                          // quantidade disponível no estoque
                          const currentStock = product.stock_quantity ?? product.stock ?? 0;

                          // quantidade originalmente reservada neste pedido (quando veio do banco)
                          const reserved = item.reserved_quantity || 0;

                          // estoque disponível real nesta edição
                          const available = currentStock + reserved;

                          if (newQty > available) {
                            alert(`Estoque insuficiente! Máximo permitido: ${available}`);
                            return;
                          }

                          setItems((prev) =>
                            prev.map((it, idx) =>
                              idx === i ? { ...it, quantity: newQty } : it
                            )
                          );
                        }}
                        className="w-20 p-1 border rounded text-center"
                      />
                    </td>
                    <td className="px-4 py-2">R${item.price.toFixed(2)}</td>
                    <td className="px-4 py-2">R${(item.price * item.quantity).toFixed(2)}</td>
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
          </div>
        )}

        <div className="sm:col-span-2 text-right text-lg font-semibold">
          Total: R$
          {items.reduce((sum, i) => sum + i.quantity * i.price, 0).toFixed(2)}
        </div>

        <div className="sm:col-span-2 flex gap-2 justify-end">
          <button
            type="submit"
            className={`${editingOrder ? "bg-yellow-500 hover:bg-yellow-600" : "bg-green-500 hover:bg-green-600"
              } text-white px-4 py-2 rounded transition w-full sm:w-auto`}
          >
            {editingOrder ? "Atualizar Pedido" : "Criar Pedido"}
          </button>
          {editingOrder && (
            <button
              type="button"
              onClick={onCancel}
              className="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400 w-full sm:w-auto"
            >
              Cancelar
            </button>
          )}
        </div>
      </form>
    </FormContainer>
  );
};

export default OrderForm;