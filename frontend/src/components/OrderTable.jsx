import React from "react";

const OrderTable = ({ orders, setEditingOrder, fetchOrders }) => {
  const handleDelete = async (id) => {
    if (!window.confirm("Deseja realmente excluir este pedido?")) return;
    try {
      await fetchOrders(id); // substitua pelo endpoint delete se tiver
      fetchOrders();
    } catch (err) {
      console.error(err);
    }
  };

  return (
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
        {orders.map(order => (
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
            <td className="p-2 flex gap-2">
              <button
                onClick={() => setEditingOrder(order)}
                className="bg-yellow-400 text-white px-2 py-1 rounded hover:bg-yellow-500"
              >
                Editar
              </button>
              <button
                onClick={() => handleDelete(order.order_id)}
                className="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600"
              >
                Excluir
              </button>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
};

export default OrderTable;
