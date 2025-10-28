import React from "react";

const OrderTable = ({ orders, setEditingOrder, fetchOrders }) => {
  const handleDelete = async (id) => {
    if (!window.confirm("Deseja realmente excluir este pedido?")) return;
    try {
      await fetchOrders(id); // substituir pelo endpoint delete se existir
      fetchOrders();
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div className="w-full">
      {/* Desktop Table */}
      <div className="hidden md:block overflow-x-auto">
        <table className="w-full bg-white rounded shadow border-collapse">
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
                <td className="p-2">{order.status}</td>
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
      </div>

      {/* Mobile Cards */}
      <div className="md:hidden flex flex-col gap-4">
        {orders.map((order) => (
          <div key={order.order_id} className="bg-white shadow rounded p-4 flex flex-col gap-2">
            <p>
              <span className="font-medium">ID Pedido:</span> {order.order_id}
            </p>
            <p>
              <span className="font-medium">Cliente:</span> {order.client_name}
            </p>
            <p>
              <span className="font-medium">Itens:</span>
              {order.items.map((item, idx) => (
                <div key={idx} className="ml-2">
                  {item.product_name} x {item.quantity} (R${item.price.toFixed(2)})
                </div>
              ))}
            </p>
            <p>
              <span className="font-medium">Total:</span> R${Number(order.total).toFixed(2)}
            </p>
            <p>
              <span className="font-medium">Status:</span> {order.status}
            </p>
            <div className="flex gap-2 mt-2">
              <button
                className="bg-yellow-400 text-white px-3 py-1 rounded hover:bg-yellow-500 transition flex-1"
                onClick={() => setEditingOrder(order)}
              >
                Editar
              </button>
              <button
                className="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600 transition flex-1"
                onClick={() => handleDelete(order.order_id)}
              >
                Excluir
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default OrderTable;