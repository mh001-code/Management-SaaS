import React from "react";

const ProductTable = ({ products, onEdit, onDelete }) => {
  return (
    <table className="w-full bg-white rounded shadow border-collapse">
      <thead className="bg-gray-200">
        <tr>
          <th className="p-2 text-left">Nome</th>
          <th className="p-2 text-left">Preço</th>
          <th className="p-2 text-left">Estoque</th>
          <th className="p-2 text-left">Ações</th>
        </tr>
      </thead>
      <tbody>
        {products.map((p) => (
          <tr key={p.id} className="border-b hover:bg-gray-50 transition">
            <td className="p-2">{p.name}</td>
            <td className="p-2">R$ {Number(p.price).toFixed(2)}</td>
            <td className="p-2">{p.stock_quantity}</td>
            <td className="p-2">
              <div className="flex gap-2">
                <button
                  onClick={() => onEdit(p)}
                  className="bg-yellow-400 text-white px-2 py-1 rounded hover:bg-yellow-500 transition"
                >
                  Editar
                </button>
                <button
                  onClick={() => onDelete(p.id)}
                  className="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600 transition"
                >
                  Deletar
                </button>
              </div>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
};

export default ProductTable;
