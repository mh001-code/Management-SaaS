import React from "react";

const ProductTable = ({ products, onEdit, onDelete }) => {
  return (
    <div className="w-full">
      {/* Desktop Table */}
      <div className="hidden md:block overflow-x-auto w-full">
        <table className="w-full bg-white rounded shadow border-collapse">
          <thead className="bg-gray-200">
            <tr>
              <th className="p-4 text-left">Nome</th>
              <th className="p-4 text-left">Preço</th>
              <th className="p-4 text-left">Estoque</th>
              <th className="p-4 text-left">Ações</th>
            </tr>
          </thead>
          <tbody>
            {products.map((p) => (
              <tr key={p.id} className="border-b hover:bg-gray-50 transition">
                <td className="p-4">{p.name}</td>
                <td className="p-4">R$ {Number(p.price).toFixed(2)}</td>
                <td className="p-4">{p.stock_quantity}</td>
                <td className="p-4 flex gap-2 justify-center">
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
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Mobile Cards */}
      <div className="md:hidden flex flex-col gap-4">
        {products.map((p) => (
          <div key={p.id} className="bg-white shadow rounded p-4 flex flex-col gap-2">
            <p>
              <span className="font-medium">Nome:</span> {p.name}
            </p>
            <p>
              <span className="font-medium">Preço:</span> R$ {Number(p.price).toFixed(2)}
            </p>
            <p>
              <span className="font-medium">Estoque:</span> {p.stock_quantity}
            </p>
            <div className="flex gap-2 mt-2">
              <button
                onClick={() => onEdit(p)}
                className="bg-yellow-400 text-white px-3 py-1 rounded hover:bg-yellow-500 transition flex-1"
              >
                Editar
              </button>
              <button
                onClick={() => onDelete(p.id)}
                className="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600 transition flex-1"
              >
                Deletar
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ProductTable;