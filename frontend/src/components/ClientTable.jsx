import React from "react";
import api from "../services/api";

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

  return (
    <div className="w-full">
      {/* Desktop Table */}
      <div className="hidden md:block overflow-x-auto w-full">
        <table className="w-full border-collapse bg-white min-w-full">
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
      </div>

      {/* Mobile Cards */}
      <div className="md:hidden flex flex-col gap-4">
        {clients.map((client) => (
          <div
            key={client.id}
            className="bg-white shadow rounded p-4 flex flex-col gap-2"
          >
            <p>
              <span className="font-medium">Nome:</span> {client.name}
            </p>
            <p>
              <span className="font-medium">Email:</span> {client.email}
            </p>
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
          </div>
        ))}
      </div>
    </div>
  );
};

export default ClientTable;