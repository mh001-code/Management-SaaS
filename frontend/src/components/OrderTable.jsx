import React from "react";
import TableContainer from "./TableContainer";
import CardTable from "./CardTable";

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

  const renderMobileRow = (order) => (
    <>
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
      <p><span className="font-medium">Status:</span> {order.status}</p>
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
    </>
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
                  <span
                    className={`px-2 py-1 rounded text-white text-sm ${order.status === "pendente" && "bg-yellow-500"} 
                      ${order.status === "pago" && "bg-green-600"}
                      ${order.status === "enviado" && "bg-blue-600"}
                      ${order.status === "concluído" && "bg-purple-600"}
                      ${order.status === "cancelado" && "bg-red-600"}
                    `}
                  >
                    {order.status}
                  </span>
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