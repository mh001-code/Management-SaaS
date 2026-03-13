import React, { memo, useCallback } from 'react';
import PropTypes from 'prop-types';
import Button from './ui/Button';

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
      <div className="flex-center p-8">
        <div className="spinner" />
      </div>
    );
  }

  if (!rows || rows.length === 0) {
    return (
      <div className="empty-state">
        <div className="empty-state-icon">📊</div>
        <div className="empty-state-text">{emptyMessage}</div>
      </div>
    );
  }

  return (
    <>
      {/* Desktop Table */}
      <div className="hidden-mobile overflow-x-auto">
        <table style={{
          width: '100%',
          borderCollapse: 'collapse',
          fontSize: 'var(--text-base)',
        }}>
          <thead>
            <tr style={{
              backgroundColor: 'rgba(255,255,255,0.04)',
              borderBottom: '1px solid var(--color-border)',
            }}>
              {columns.map((col) => (
                <th
                  key={col.key}
                  style={{
                    padding: 'var(--space-md)',
                    textAlign: col.align || 'left',
                    fontWeight: '600',
                    color: 'var(--color-text)',
                    fontFamily: 'var(--font-display)',
                    fontSize: 'var(--text-sm)',
                  }}
                >
                  {col.label}
                </th>
              ))}
              {(onEdit || onDelete) && (
                <th style={{
                  padding: 'var(--space-md)',
                  textAlign: 'center',
                  fontWeight: '600',
                  color: 'var(--color-text)',
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
                  borderBottom: '1px solid var(--color-border)',
                  transition: 'all var(--transition-base) ease',
                }}
                onMouseEnter={(e) => e.currentTarget.style.backgroundColor = 'rgba(255,255,255,0.02)'}
                onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'transparent'}
              >
                {columns.map((col) => (
                  <td
                    key={col.key}
                    style={{
                      padding: 'var(--space-md)',
                      textAlign: col.align || 'left',
                      color: 'var(--color-text)',
                    }}
                  >
                    {col.render ? col.render(row[col.key], row) : row[col.key]}
                  </td>
                ))}
                {(onEdit || onDelete) && (
                  <td style={{
                    padding: 'var(--space-md)',
                    textAlign: 'center',
                    display: 'flex',
                    gap: 'var(--space-sm)',
                    justifyContent: 'center',
                  }}>
                    {onEdit && (
                      <Button
                        variant="warning"
                        size="sm"
                        onClick={() => handleEdit(row)}
                        style={{ minWidth: 'auto' }}
                      >
                        ✎ Editar
                      </Button>
                    )}
                    {onDelete && (
                      <Button
                        variant="danger"
                        size="sm"
                        onClick={() => handleDelete(row[rowKey])}
                        style={{ minWidth: 'auto' }}
                      >
                        🗑 Deletar
                      </Button>
                    )}
                  </td>
                )}
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Mobile Cards */}
      <div className="visible-mobile" style={{ display: 'flex', flexDirection: 'column', gap: 'var(--space-md)' }}>
        {rows.map((row, idx) => (
          <div
            key={row[rowKey] || idx}
            style={{
              backgroundColor: 'var(--color-surface)',
              border: '1px solid var(--color-border)',
              borderRadius: 'var(--radius-lg)',
              padding: 'var(--space-md)',
            }}
          >
            {columns.map((col) => (
              <div key={col.key} style={{ marginBottom: 'var(--space-md)' }}>
                <span style={{
                  fontWeight: '600',
                  color: 'var(--color-primary)',
                  fontSize: 'var(--text-xs)',
                  textTransform: 'uppercase',
                  letterSpacing: '0.5px',
                }}>
                  {col.label}:
                </span>
                <span style={{
                  marginLeft: 'var(--space-md)',
                  color: 'var(--color-text)',
                }}>
                  {col.render ? col.render(row[col.key], row) : row[col.key]}
                </span>
              </div>
            ))}
            {(onEdit || onDelete) && (
              <div style={{
                display: 'flex',
                gap: 'var(--space-sm)',
                marginTop: 'var(--space-md)',
              }}>
                {onEdit && (
                  <Button
                    variant="warning"
                    size="sm"
                    onClick={() => handleEdit(row)}
                    style={{ flex: 1 }}
                  >
                    ✎ Editar
                  </Button>
                )}
                {onDelete && (
                  <Button
                    variant="danger"
                    size="sm"
                    onClick={() => handleDelete(row[rowKey])}
                    style={{ flex: 1 }}
                  >
                    🗑 Deletar
                  </Button>
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
