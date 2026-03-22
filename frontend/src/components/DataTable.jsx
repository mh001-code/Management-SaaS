import React, { memo, useCallback } from "react";

const SkeletonRow = ({ cols }) => (
  <tr>
    {Array.from({ length: cols }).map((_, i) => (
      <td key={i} style={{ padding: "14px 16px" }}>
        <div
          style={{
            height: 13,
            borderRadius: 6,
            width: i === 0 ? "60%" : i % 2 === 0 ? "80%" : "50%",
            background: "linear-gradient(90deg,var(--color-surface2) 0%,var(--color-surface3) 50%,var(--color-surface2) 100%)",
            backgroundSize: "200% 100%",
            animation: "shimmer 1.4s ease-in-out infinite",
          }}
        />
      </td>
    ))}
    <td style={{ padding: "14px 16px" }}>
      <div style={{ display: "flex", gap: 6, justifyContent: "center" }}>
        {[56, 64].map((w, i) => (
          <div
            key={i}
            style={{
              height: 28,
              width: w,
              borderRadius: 7,
              background: "linear-gradient(90deg,var(--color-surface2) 0%,var(--color-surface3) 50%,var(--color-surface2) 100%)",
              backgroundSize: "200% 100%",
              animation: `shimmer 1.4s ease-in-out ${i * 0.1}s infinite`,
            }}
          />
        ))}
      </div>
    </td>
  </tr>
);

const EmptyState = ({ message, icon }) => (
  <tr>
    <td colSpan={99}>
      <div
        style={{
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          padding: "52px 20px",
          gap: 12,
          color: "var(--color-textMuted)",
        }}
      >
        <svg
          width="40"
          height="40"
          viewBox="0 0 40 40"
          fill="none"
          style={{ opacity: 0.35 }}
        >
          {icon === "clients" && (
            <>
              <circle cx="20" cy="14" r="7" stroke="currentColor" strokeWidth="1.5" />
              <path d="M5 36c0-8 6.7-13 15-13s15 5 15 13" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
            </>
          )}
          {icon === "products" && (
            <>
              <rect x="6" y="6" width="28" height="28" rx="4" stroke="currentColor" strokeWidth="1.5" />
              <path d="M13 20h14M20 13v14" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
            </>
          )}
          {icon === "orders" && (
            <>
              <rect x="6" y="4" width="28" height="32" rx="3" stroke="currentColor" strokeWidth="1.5" />
              <path d="M13 14h14M13 20h14M13 26h8" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
            </>
          )}
          {icon === "users" && (
            <>
              <circle cx="14" cy="14" r="5" stroke="currentColor" strokeWidth="1.5" />
              <circle cx="26" cy="14" r="5" stroke="currentColor" strokeWidth="1.5" />
              <path d="M4 34c0-5 4.5-9 10-9M22 25c5.5 0 10 4 10 9" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
              <path d="M16 25c2 0 4 .4 6 1.2" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
            </>
          )}
          {!["clients","products","orders","users"].includes(icon) && (
            <>
              <rect x="6" y="6" width="28" height="28" rx="4" stroke="currentColor" strokeWidth="1.5" />
              <path d="M14 20h12M20 14v12" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
            </>
          )}
        </svg>
        <span style={{ fontSize: 14, fontWeight: 500 }}>{message}</span>
        <span style={{ fontSize: 12, opacity: 0.6 }}>Os dados aparecerão aqui quando disponíveis</span>
      </div>
    </td>
  </tr>
);

const DataTable = memo(({
  rows = [],
  columns = [],
  onEdit = null,
  onDelete = null,
  isLoading = false,
  emptyMessage = "Nenhum dado encontrado",
  emptyIcon = "default",
  rowKey = "id",
  skeletonRows = 5,
}) => {
  const handleEdit = useCallback((row) => onEdit?.(row), [onEdit]);
  const handleDelete = useCallback((id) => {
    if (window.confirm("Tem certeza que deseja deletar? Esta ação não pode ser desfeita.")) {
      onDelete?.(id);
    }
  }, [onDelete]);

  const hasActions = onEdit || onDelete;
  const totalCols = columns.length + (hasActions ? 1 : 0);

  return (
    <>
      <style>{`
        @keyframes shimmer {
          0%   { background-position: 200% 0; }
          100% { background-position: -200% 0; }
        }
        .dt-table { width: 100%; border-collapse: collapse; font-size: 13px; }

        .dt-th {
          padding: 11px 16px;
          text-align: left;
          font-size: 11px;
          font-weight: 600;
          color: var(--color-textMuted);
          text-transform: uppercase;
          letter-spacing: 0.8px;
          background: var(--color-surface2);
          border-bottom: 1px solid var(--color-border);
          white-space: nowrap;
        }
        .dt-th:first-child { border-radius: 8px 0 0 0; }
        .dt-th:last-child  { border-radius: 0 8px 0 0; text-align: center; }

        .dt-tr {
          border-bottom: 1px solid var(--color-border);
          transition: background 150ms ease;
        }
        .dt-tr:last-child { border-bottom: none; }
        .dt-tr:hover { background: rgba(124,106,247,0.06); }

        .dt-td {
          padding: 13px 16px;
          color: var(--color-text);
          vertical-align: middle;
        }
        .dt-td-actions {
          padding: 10px 16px;
          text-align: center;
          white-space: nowrap;
        }

        .dt-btn-edit {
          display: inline-flex; align-items: center; gap: 5px;
          padding: 5px 11px; border-radius: 7px; border: none;
          background: rgba(124,106,247,0.1); color: var(--color-primary);
          font-size: 12px; font-weight: 600; font-family: var(--font-body);
          cursor: pointer; transition: all 150ms;
          margin-right: 6px;
        }
        .dt-btn-edit:hover { background: rgba(124,106,247,0.2); transform: translateY(-1px); }

        .dt-btn-delete {
          display: inline-flex; align-items: center; gap: 5px;
          padding: 5px 11px; border-radius: 7px; border: none;
          background: rgba(247,100,100,0.08); color: var(--color-danger);
          font-size: 12px; font-weight: 600; font-family: var(--font-body);
          cursor: pointer; transition: all 150ms;
        }
        .dt-btn-delete:hover { background: rgba(247,100,100,0.18); transform: translateY(-1px); }

        .dt-mobile-card {
          background: var(--color-surface);
          border: 1px solid var(--color-border);
          border-radius: 12px;
          padding: 14px 16px;
          margin-bottom: 10px;
          animation: fadeUp .35s cubic-bezier(0.22,1,0.36,1) both;
        }
        .dt-mobile-field { display: flex; flex-direction: column; gap: 2px; margin-bottom: 10px; }
        .dt-mobile-label { font-size: 10px; font-weight: 600; color: var(--color-textMuted); text-transform: uppercase; letter-spacing: 0.7px; }
        .dt-mobile-value { font-size: 13px; color: var(--color-text); font-weight: 500; }
        .dt-mobile-actions { display: flex; gap: 8px; margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--color-border); }
        .dt-mobile-actions .dt-btn-edit,
        .dt-mobile-actions .dt-btn-delete { flex: 1; justify-content: center; margin-right: 0; }

        @keyframes fadeUp {
          from { opacity: 0; transform: translateY(10px); }
          to   { opacity: 1; transform: translateY(0); }
        }
      `}</style>

      {/* ── Desktop ── */}
      <div style={{ overflowX: "auto", WebkitOverflowScrolling: "touch", maxWidth: "100%" }} className="hidden-mobile">
        <table className="dt-table">
          <thead>
            <tr>
              {columns.map((col) => (
                <th key={col.key} className="dt-th" style={{ textAlign: col.align || "left" }}>
                  {col.label}
                </th>
              ))}
              {hasActions && <th className="dt-th">Ações</th>}
            </tr>
          </thead>
          <tbody>
            {isLoading
              ? Array.from({ length: skeletonRows }).map((_, i) => (
                  <SkeletonRow key={i} cols={columns.length} />
                ))
              : rows.length === 0
              ? <EmptyState message={emptyMessage} icon={emptyIcon} />
              : rows.map((row, idx) => (
                  <tr
                    key={row[rowKey] ?? idx}
                    className="dt-tr"
                    style={{ animationDelay: `${idx * 30}ms` }}
                  >
                    {columns.map((col) => (
                      <td
                        key={col.key}
                        className="dt-td"
                        style={{ textAlign: col.align || "left" }}
                      >
                        {col.render
                          ? col.render(row[col.key], row)
                          : row[col.key] ?? "—"}
                      </td>
                    ))}
                    {hasActions && (
                      <td className="dt-td-actions">
                        {onEdit && (
                          <button className="dt-btn-edit" onClick={() => handleEdit(row)}>
                            <svg width="12" height="12" viewBox="0 0 16 16" fill="none">
                              <path d="M11 2l3 3-9 9H2v-3l9-9z" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round"/>
                            </svg>
                            Editar
                          </button>
                        )}
                        {onDelete && (
                          <button className="dt-btn-delete" onClick={() => handleDelete(row[rowKey])}>
                            <svg width="12" height="12" viewBox="0 0 16 16" fill="none">
                              <path d="M2 4h12M5 4V2h6v2M6 7v5M10 7v5M3 4l1 10h8l1-10" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
                            </svg>
                            Deletar
                          </button>
                        )}
                      </td>
                    )}
                  </tr>
                ))
            }
          </tbody>
        </table>
      </div>

      {/* ── Mobile cards ── */}
      <div className="visible-mobile">
        {isLoading
          ? Array.from({ length: 3 }).map((_, i) => (
              <div key={i} className="dt-mobile-card">
                {columns.slice(0, 3).map((_, j) => (
                  <div key={j} style={{ marginBottom: 10 }}>
                    <div className="skeleton" style={{ height: 10, width: "40%", marginBottom: 4 }} />
                    <div className="skeleton" style={{ height: 13, width: `${60 + j * 10}%` }} />
                  </div>
                ))}
              </div>
            ))
          : rows.length === 0
          ? (
              <div className="empty-state">
                <div className="empty-state-icon">📋</div>
                <div className="empty-state-text">{emptyMessage}</div>
              </div>
            )
          : rows.map((row, idx) => (
              <div
                key={row[rowKey] ?? idx}
                className="dt-mobile-card"
                style={{ animationDelay: `${idx * 40}ms` }}
              >
                {columns.map((col) => (
                  <div key={col.key} className="dt-mobile-field">
                    <span className="dt-mobile-label">{col.label}</span>
                    <span className="dt-mobile-value">
                      {col.render ? col.render(row[col.key], row) : row[col.key] ?? "—"}
                    </span>
                  </div>
                ))}
                {hasActions && (
                  <div className="dt-mobile-actions">
                    {onEdit && (
                      <button className="dt-btn-edit" onClick={() => handleEdit(row)}>
                        Editar
                      </button>
                    )}
                    {onDelete && (
                      <button className="dt-btn-delete" onClick={() => handleDelete(row[rowKey])}>
                        Deletar
                      </button>
                    )}
                  </div>
                )}
              </div>
            ))
        }
      </div>
    </>
  );
});

DataTable.displayName = "DataTable";
export default DataTable;