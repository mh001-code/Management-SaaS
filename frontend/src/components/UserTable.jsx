import React from "react";

const UserTable = ({ users, onEdit, onDelete }) => {
  return (
    <table className="w-full border-collapse bg-white shadow rounded">
      <thead className="bg-gray-100">
        <tr>
          <th className="border px-4 py-2">Nome</th>
          <th className="border px-4 py-2">Email</th>
          <th className="border px-4 py-2">Função</th>
          <th className="border px-4 py-2">Ações</th>
        </tr>
      </thead>
      <tbody>
        {users.map((u) => (
          <tr key={u.id} className="border-b hover:bg-gray-50">
            <td className="px-4 py-2">{u.name}</td>
            <td className="px-4 py-2">{u.email}</td>
            <td className="px-4 py-2">{u.role}</td>
            <td className="px-4 py-2 flex gap-2">
              <button
                className="bg-yellow-400 px-2 py-1 rounded hover:bg-yellow-500 transition"
                onClick={() => onEdit(u)}
              >
                Editar
              </button>
              <button
                className="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600 transition"
                onClick={() => onDelete(u.id)}
              >
                Deletar
              </button>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
};

export default UserTable;