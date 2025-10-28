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
    <table className="w-full border-collapse bg-white shadow rounded">
      <thead className="bg-gray-100">
        <tr>
          <th className="border px-4 py-2">Nome</th>
          <th className="border px-4 py-2">Email</th>
          <th className="border px-4 py-2">Ações</th>
        </tr>
      </thead>
      <tbody>
        {clients.map((client) => (
          <tr key={client.id} className="border-b hover:bg-gray-50">
            <td className="px-4 py-2">{client.name}</td>
            <td className="px-4 py-2">{client.email}</td>
            <td className="px-4 py-2 flex gap-2">
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
  );
};

export default ClientTable;