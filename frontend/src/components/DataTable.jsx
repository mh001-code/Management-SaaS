import React, { memo, useCallback } from 'react';
import PropTypes from 'prop-types';

/**
 * Componente genérico de tabela otimizado
 * Suporta desktop e mobile (responsivo)
 * Memoizado para evitar re-renders desnecessários
 */
const DataTable = memo(({
  rows = [],
  columns = [],
  onEdit = null,
  onDelete = null,
  isLoading = false,
  emptyMessage = 'Nenhum dado encontrado',
  rowKey = 'id',
}) => {
  const handleEdit = useCallback((row) => {
    onEdit?.(row);
  }, [onEdit]);

  const handleDelete = useCallback((id) => {
    if (window.confirm('Tem certeza que deseja deletar?')) {
      onDelete?.(id);
    }
  }, [onDelete]);

  if (isLoading) {
    return (
      <div className="flex justify-center items-center p-8">
        <div className="spinner-ring" style={{
          width: '40px',
          height: '40px',
          border: '3px solid rgba(255,255,255,0.1)',
          borderTopColor: '#4f6ef7',
          borderRadius: '50%',
          animation: 'spin 1s linear infinite',
        }} />
      </div>
    );
  }

  if (!rows || rows.length === 0) {
    return (
      <div style={{
        textAlign: 'center',
        padding: '40px',
        color: 'rgba(255,255,255,0.35)',
      }}>
        {emptyMessage}
      </div>
    );
  }

  return (
    <>
      {/* Desktop Table */}
      <div className="hidden md:block overflow-x-auto">
        <table style={{
          width: '100%',
          borderCollapse: 'collapse',
          fontSize: '14px',
        }}>
          <thead>
            <tr style={{
              backgroundColor: 'rgba(255,255,255,0.04)',
              borderBottom: '1px solid rgba(255,255,255,0.06)',
            }}>
              {columns.map((col) => (
                <th
                  key={col.key}
                  style={{
                    padding: '12px',
                    textAlign: col.align || 'left',
                    fontWeight: '600',
                    color: '#e8e8f0',
                  }}
                >
                  {col.label}
                </th>
              ))}
              {(onEdit || onDelete) && (
                <th style={{
                  padding: '12px',
                  textAlign: 'center',
                  fontWeight: '600',
                  color: '#e8e8f0',
                }}>
                  Ações
                </th>
              )}
            </tr>
          </thead>
          <tbody>
            {rows.map((row, idx) => (
              <tr
                key={row[rowKey] || idx}
                style={{
                  borderBottom: '1px solid rgba(255,255,255,0.06)',
                  transition: 'background 0.15s',
                }}
                onMouseEnter={(e) => e.currentTarget.style.backgroundColor = 'rgba(255,255,255,0.02)'}
                onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'transparent'}
              >
                {columns.map((col) => (
                  <td
                    key={col.key}
                    style={{
                      padding: '12px',
                      textAlign: col.align || 'left',
                      color: '#e8e8f0',
                    }}
                  >
                    {col.render ? col.render(row[col.key], row) : row[col.key]}
                  </td>
                ))}
                {(onEdit || onDelete) && (
                  <td style={{
                    padding: '12px',
                    textAlign: 'center',
                    display: 'flex',
                    gap: '8px',
                    justifyContent: 'center',
                  }}>
                    {onEdit && (
                      <button
                        onClick={() => handleEdit(row)}
                        style={{
                          padding: '6px 12px',
                          backgroundColor: '#f59e0b',
                          color: 'white',
                          border: 'none',
                          borderRadius: '6px',
                          cursor: 'pointer',
                          fontSize: '12px',
                          fontWeight: '500',
                          transition: 'background 0.15s',
                        }}
                        onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f08a00'}
                        onMouseLeave={(e) => e.currentTarget.style.backgroundColor = '#f59e0b'}
                      >
                        Editar
                      </button>
                    )}
                    {onDelete && (
                      <button
                        onClick={() => handleDelete(row[rowKey])}
                        style={{
                          padding: '6px 12px',
                          backgroundColor: '#ef4444',
                          color: 'white',
                          border: 'none',
                          borderRadius: '6px',
                          cursor: 'pointer',
                          fontSize: '12px',
                          fontWeight: '500',
                          transition: 'background 0.15s',
                        }}
                        onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#dc2626'}
                        onMouseLeave={(e) => e.currentTarget.style.backgroundColor = '#ef4444'}
                      >
                        Deletar
                      </button>
                    )}
                  </td>
                )}
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Mobile Cards */}
      <div className="md:hidden space-y-3">
        {rows.map((row, idx) => (
          <div
            key={row[rowKey] || idx}
            style={{
              backgroundColor: '#17171f',
              border: '1px solid rgba(255,255,255,0.06)',
              borderRadius: '8px',
              padding: '12px',
            }}
          >
            {columns.map((col) => (
              <div key={col.key} style={{ marginBottom: '8px' }}>
                <span style={{
                  fontWeight: '600',
                  color: '#4f6ef7',
                  fontSize: '12px',
                  textTransform: 'uppercase',
                  letterSpacing: '0.5px',
                }}>
                  {col.label}:
                </span>
                <span style={{
                  marginLeft: '8px',
                  color: '#e8e8f0',
                }}>
                  {col.render ? col.render(row[col.key], row) : row[col.key]}
                </span>
              </div>
            ))}
            {(onEdit || onDelete) && (
              <div style={{
                display: 'flex',
                gap: '8px',
                marginTop: '12px',
              }}>
                {onEdit && (
                  <button
                    onClick={() => handleEdit(row)}
                    style={{
                      flex: 1,
                      padding: '8px',
                      backgroundColor: '#f59e0b',
                      color: 'white',
                      border: 'none',
                      borderRadius: '6px',
                      cursor: 'pointer',
                      fontSize: '12px',
                      fontWeight: '500',
                    }}
                  >
                    Editar
                  </button>
                )}
                {onDelete && (
                  <button
                    onClick={() => handleDelete(row[rowKey])}
                    style={{
                      flex: 1,
                      padding: '8px',
                      backgroundColor: '#ef4444',
                      color: 'white',
                      border: 'none',
                      borderRadius: '6px',
                      cursor: 'pointer',
                      fontSize: '12px',
                      fontWeight: '500',
                    }}
                  >
                    Deletar
                  </button>
                )}
              </div>
            )}
          </div>
        ))}
      </div>
    </>
  );
});

DataTable.displayName = 'DataTable';

DataTable.propTypes = {
  rows: PropTypes.array.isRequired,
  columns: PropTypes.arrayOf(PropTypes.shape({
    key: PropTypes.string.isRequired,
    label: PropTypes.string.isRequired,
    render: PropTypes.func,
    align: PropTypes.oneOf(['left', 'center', 'right']),
  })).isRequired,
  onEdit: PropTypes.func,
  onDelete: PropTypes.func,
  isLoading: PropTypes.bool,
  emptyMessage: PropTypes.string,
  rowKey: PropTypes.string,
};

export default DataTable;
