import React from "react";
import TableContainer from "./TableContainer";
import CardTable from "./CardTable";
import api from "../services/api";

const nextStatuses = {
  pendente: ["pago", "cancelado"],
  pago: ["enviado", "cancelado"],
  enviado: ["entregue", "estornado", "recusado", "cancelado"],
  entregue: ["estornado", "cancelado"],
  concluído: [],
  cancelado: [],
  estornado: [],
  recusado: []
};

const label = {
  pendente: "Pendente",
  pago: "Pago",
  enviado: "Enviado",
  entregue: "Entregue",
  concluído: "Concluído",
  cancelado: "Cancelado",
  estornado: "Estornado",
  recusado: "Recusado"
};

const OrderTable = ({ orders, setEditingOrder, fetchOrders }) => {
  const handleDelete = async (id) => {
    if (!window.confirm("Deseja realmente excluir este pedido?")) return;
    try {
      await api.delete(`/orders/${id}`);
      fetchOrders();
    } catch (err) {
      console.error("Erro ao deletar pedido:", err);
    }
  };

  const handleStatusChange = async (id, status) => {
    try {
      await api.put(`/orders/${id}/status`, { status });
      fetchOrders();
    } catch (err) {
      console.error("Erro ao atualizar status:", err);
    }
  };

  const renderMobileRow = (order) => (
    <div className="border rounded p-4 mb-4 shadow bg-white">
      <p><span className="font-medium">ID Pedido:</span> {order.order_id}</p>
      <p><span className="font-medium">Cliente:</span> {order.client_name}</p>
      <div>
        <span className="font-medium">Itens:</span>
        {order.items.map((item, idx) => (
          <div key={idx} className="ml-2">
            {item.product_name} x {item.quantity} (R${item.price.toFixed(2)})
          </div>
        ))}
      </div>
      <p><span className="font-medium">Total:</span> R${Number(order.total).toFixed(2)}</p>
      <div className="flex items-center gap-2 mt-1">
        <span className={`inline-block px-2 py-1 rounded text-white text-xs font-semibold
          ${order.status === "pendente" && "bg-amber-600"}
          ${order.status === "pago" && "bg-emerald-600"}
          ${order.status === "enviado" && "bg-sky-600"}
          ${order.status === "entregue" && "bg-teal-600"}
          ${order.status === "concluído" && "bg-indigo-600"}
          ${order.status === "cancelado" && "bg-rose-600"}
          ${order.status === "estornado" && "bg-gray-600"}
          ${order.status === "recusado" && "bg-red-700"}
        `}>
          {label[order.status]}
        </span>

        {/* Renderiza select apenas se houver opções */}
        {nextStatuses[order.status]?.length > 0 && (
          <select
            defaultValue=""
            onChange={(e) => handleStatusChange(order.order_id, e.target.value)}
            className="border border-gray-300 rounded px-2 py-1 text-sm cursor-pointer hover:border-gray-500 transition focus:outline-none focus:ring-1 focus:ring-gray-400"
          >
            <option value="" disabled>Alterar...</option>
            {nextStatuses[order.status].map((s) => (
              <option key={s} value={s}>{label[s]}</option>
            ))}
          </select>
        )}
      </div>
      <div className="flex gap-2 mt-2">
        <button
          onClick={() => setEditingOrder(order)}
          className="bg-yellow-400 text-white px-3 py-1 rounded hover:bg-yellow-500 transition flex-1"
        >
          Editar
        </button>
        <button
          onClick={() => handleDelete(order.order_id)}
          className="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600 transition flex-1"
        >
          Excluir
        </button>
      </div>
    </div>
  );

  return (
    <>
      <TableContainer>
        <table className="hidden md:table w-full bg-white rounded shadow border-collapse">
          <thead className="bg-gray-200">
            <tr>
              <th className="p-2 text-left">ID Pedido</th>
              <th className="p-2 text-left">Cliente</th>
              <th className="p-2 text-left">Itens</th>
              <th className="p-2 text-left">Total</th>
              <th className="p-2 text-left">Status</th>
              <th className="p-2 text-left">Ações</th>
            </tr>
          </thead>
          <tbody>
            {orders.map((order) => (
              <tr key={order.order_id} className="border-b hover:bg-gray-50 transition">
                <td className="p-2">{order.order_id}</td>
                <td className="p-2">{order.client_name}</td>
                <td className="p-2">
                  {order.items.map((item, idx) => (
                    <div key={idx}>
                      {item.product_name} x {item.quantity} (R${item.price.toFixed(2)})
                    </div>
                  ))}
                </td>
                <td className="p-2">R${Number(order.total).toFixed(2)}</td>
                <td className="p-2">
                  <div className="flex items-center gap-2">
                    <span className={`inline-block px-2 py-1 rounded text-white text-xs font-semibold
                    ${order.status === "pendente" && "bg-amber-600"}
                    ${order.status === "pago" && "bg-emerald-600"}
                    ${order.status === "enviado" && "bg-sky-600"}
                    ${order.status === "entregue" && "bg-teal-600"}
                    ${order.status === "concluído" && "bg-indigo-600"}
                    ${order.status === "cancelado" && "bg-rose-600"}
                    ${order.status === "estornado" && "bg-gray-600"}
                    ${order.status === "recusado" && "bg-red-700"}
                  `}>
                      {label[order.status]}
                    </span>

                    {/* Renderiza select apenas se houver opções */}
                    {nextStatuses[order.status]?.length > 0 && (
                      <select
                        defaultValue=""
                        onChange={(e) => handleStatusChange(order.order_id, e.target.value)}
                        className="border border-gray-300 rounded px-2 py-1 text-sm cursor-pointer hover:border-gray-500 transition focus:outline-none focus:ring-1 focus:ring-gray-400"
                      >
                        <option value="" disabled>Alterar...</option>
                        {nextStatuses[order.status].map((s) => (
                          <option key={s} value={s}>{label[s]}</option>
                        ))}
                      </select>
                    )}
                  </div>
                </td>
                <td className="p-2 flex gap-2 justify-center">
                  <button
                    onClick={() => setEditingOrder(order)}
                    className="bg-yellow-400 text-white px-2 py-1 rounded hover:bg-yellow-500 transition"
                  >
                    Editar
                  </button>
                  <button
                    onClick={() => handleDelete(order.order_id)}
                    className="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600 transition"
                  >
                    Excluir
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </TableContainer>

      <CardTable data={orders} renderRow={renderMobileRow} emptyMessage="Nenhum pedido encontrado." />
    </>
  );
};

export default OrderTable;