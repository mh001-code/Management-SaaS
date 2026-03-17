import React, { memo } from "react";

const Pagination = memo(({ currentPage, totalPages, onPageChange }) => {
  if (totalPages <= 1) return null;

  return (
    <div
      style={{
        display: "flex",
        gap: "8px",
        justifyContent: "center",
        marginTop: "20px",
        flexWrap: "wrap",
      }}
    >
      <button
        onClick={() => onPageChange(currentPage - 1)}
        disabled={currentPage === 1}
        style={{
          padding: "8px 12px",
          backgroundColor: currentPage === 1 ? "#555" : "#4f6ef7",
          color: "white",
          border: "none",
          borderRadius: "6px",
          cursor: currentPage === 1 ? "not-allowed" : "pointer",
          opacity: currentPage === 1 ? 0.5 : 1,
        }}
      >
        ← Anterior
      </button>

      {Array.from({ length: totalPages }, (_, i) => (
        <button
          key={i + 1}
          onClick={() => onPageChange(i + 1)}
          style={{
            padding: "8px 12px",
            backgroundColor: currentPage === i + 1 ? "#06b6d4" : "#17171f",
            color: "white",
            border: "1px solid rgba(255,255,255,0.06)",
            borderRadius: "6px",
            cursor: "pointer",
          }}
        >
          {i + 1}
        </button>
      ))}

      <button
        onClick={() => onPageChange(currentPage + 1)}
        disabled={currentPage === totalPages}
        style={{
          padding: "8px 12px",
          backgroundColor: currentPage === totalPages ? "#555" : "#4f6ef7",
          color: "white",
          border: "none",
          borderRadius: "6px",
          cursor: currentPage === totalPages ? "not-allowed" : "pointer",
          opacity: currentPage === totalPages ? 0.5 : 1,
        }}
      >
        Próximo →
      </button>
    </div>
  );
});

Pagination.displayName = "Pagination";

export default Pagination;
