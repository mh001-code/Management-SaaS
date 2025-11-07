import React from "react";
import api from "../services/api";
import TableContainer from "./TableContainer";
import CardTable from "./CardTable";

const ClientTable = ({ clients, setEditingClient, fetchClients }) => {
  const handleDelete = async (id) => {
    if (!window.confirm("Deseja realmente excluir este cliente?")) return;
    try {
      await api.delete(`/clients/${id}`, {
        headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
      });
      fetchClients();
    } catch (err) {
      console.error(err);
    }
  };

  const renderMobileRow = (client) => (
    <>
      <p><span className="font-medium">Nome:</span> {client.name}</p>
      <p><span className="font-medium">Email:</span> {client.email}</p>
      <div className="flex gap-2 mt-2">
        <button
          onClick={() => setEditingClient(client)}
          className="bg-yellow-400 px-3 py-1 rounded hover:bg-yellow-500 transition flex-1"
        >
          Editar
        </button>
        <button
          onClick={() => handleDelete(client.id)}
          className="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600 transition flex-1"
        >
          Excluir
        </button>
      </div>
    </>
  );

  return (
    <>
      {/* Desktop Table */}
      <TableContainer>
        <table className="hidden md:table w-full border-collapse bg-white min-w-full">
          <thead className="bg-gray-100">
            <tr>
              <th className="border px-4 py-2 text-left">Nome</th>
              <th className="border px-4 py-2 text-left">Email</th>
              <th className="border px-4 py-2 text-center">Ações</th>
            </tr>
          </thead>
          <tbody>
            {clients.map((client) => (
              <tr
                key={client.id}
                className="border-b hover:bg-gray-50 transition-all duration-300"
              >
                <td className="px-4 py-2">{client.name}</td>
                <td className="px-4 py-2">{client.email}</td>
                <td className="px-4 py-2 flex gap-2 justify-center">
                  <button
                    onClick={() => setEditingClient(client)}
                    className="bg-yellow-400 px-2 py-1 rounded hover:bg-yellow-500 transition"
                  >
                    Editar
                  </button>
                  <button
                    onClick={() => handleDelete(client.id)}
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

      {/* Mobile Cards */}
      <CardTable data={clients} renderRow={renderMobileRow} emptyMessage="Nenhum cliente cadastrado." />
    </>
  );
};

export default ClientTable;