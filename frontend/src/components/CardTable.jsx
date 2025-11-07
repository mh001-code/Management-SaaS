import React from "react";

const CardTable = ({ data, renderRow, emptyMessage = "No items found" }) => {
  if (!data || !data.length) return <p className="text-center text-gray-500 py-6">{emptyMessage}</p>;

  return (
    <div className="md:hidden flex flex-col gap-4">
      {data.map((item, idx) => (
        <div key={idx} className="bg-white shadow rounded p-4 flex flex-col gap-2">
          {renderRow(item)}
        </div>
      ))}
    </div>
  );
};

export default CardTable;
