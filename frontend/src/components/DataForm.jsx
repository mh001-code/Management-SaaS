import React, { memo, useCallback } from 'react';
import PropTypes from 'prop-types';

/**
 * Componente genérico de form otimizado
 * Suporte a validação, loading e erros
 * Memoizado para evitar re-renders desnecessários
 */
const DataForm = memo(({
  fields = [],
  values = {},
  errors = {},
  touched = {},
  isSubmitting = false,
  onSubmit = null,
  onCancel = null,
  onFieldChange = null,
  onFieldBlur = null,
  submitLabel = 'Salvar',
  cancelLabel = 'Cancelar',
  title = 'Formulário',
}) => {
  const handleSubmit = useCallback((e) => {
    e.preventDefault();
    onSubmit?.(values);
  }, [values, onSubmit]);

  const handleChange = useCallback((fieldName, value) => {
    onFieldChange?.(fieldName, value);
  }, [onFieldChange]);

  const handleBlur = useCallback((fieldName) => {
    onFieldBlur?.(fieldName, true);
  }, [onFieldBlur]);

  return (
    <form onSubmit={handleSubmit} style={{ width: '100%' }}>
      {title && (
        <div style={{
          marginBottom: '20px',
          paddingBottom: '16px',
          borderBottom: '1px solid rgba(255,255,255,0.06)',
        }}>
          <h3 style={{
            fontSize: '16px',
            fontWeight: '700',
            color: '#e8e8f0',
            margin: 0,
          }}>
            {title}
          </h3>
        </div>
      )}

      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
        gap: '16px',
        marginBottom: '24px',
      }}>
        {fields.map((field) => (
          <div key={field.name} style={{
            display: 'flex',
            flexDirection: 'column',
            gap: '6px',
          }}>
            {field.label && (
              <label style={{
                fontSize: '13px',
                fontWeight: '600',
                color: '#e8e8f0',
              }}>
                {field.label}
                {field.required && (
                  <span style={{ color: '#ef4444', marginLeft: '4px' }}>*</span>
                )}
              </label>
            )}

            {field.type === 'textarea' ? (
              <textarea
                name={field.name}
                value={values[field.name] || ''}
                onChange={(e) => handleChange(field.name, e.target.value)}
                onBlur={() => handleBlur(field.name)}
                placeholder={field.placeholder}
                rows={field.rows || 4}
                disabled={isSubmitting}
                style={{
                  padding: '10px 12px',
                  backgroundColor: '#17171f',
                  border: `1px solid ${
                    touched[field.name] && errors[field.name]
                      ? '#ef4444'
                      : 'rgba(255,255,255,0.06)'
                  }`,
                  borderRadius: '6px',
                  color: '#e8e8f0',
                  fontFamily: 'DM Sans, sans-serif',
                  fontSize: '14px',
                  transition: 'border-color 0.15s',
                  resize: 'vertical',
                }}
              />
            ) : field.type === 'select' ? (
              <select
                name={field.name}
                value={values[field.name] || ''}
                onChange={(e) => handleChange(field.name, e.target.value)}
                onBlur={() => handleBlur(field.name)}
                disabled={isSubmitting}
                style={{
                  padding: '10px 12px',
                  backgroundColor: '#17171f',
                  border: `1px solid ${
                    touched[field.name] && errors[field.name]
                      ? '#ef4444'
                      : 'rgba(255,255,255,0.06)'
                  }`,
                  borderRadius: '6px',
                  color: '#e8e8f0',
                  fontFamily: 'DM Sans, sans-serif',
                  fontSize: '14px',
                  cursor: 'pointer',
                  transition: 'border-color 0.15s',
                }}
              >
                <option value="">Selecione...</option>
                {field.options?.map((opt) => (
                  <option key={opt.value} value={opt.value}>
                    {opt.label}
                  </option>
                ))}
              </select>
            ) : (
              <input
                type={field.type || 'text'}
                name={field.name}
                value={values[field.name] || ''}
                onChange={(e) => handleChange(field.name, e.target.value)}
                onBlur={() => handleBlur(field.name)}
                placeholder={field.placeholder}
                disabled={isSubmitting}
                style={{
                  padding: '10px 12px',
                  backgroundColor: '#17171f',
                  border: `1px solid ${
                    touched[field.name] && errors[field.name]
                      ? '#ef4444'
                      : 'rgba(255,255,255,0.06)'
                  }`,
                  borderRadius: '6px',
                  color: '#e8e8f0',
                  fontFamily: 'DM Sans, sans-serif',
                  fontSize: '14px',
                  transition: 'border-color 0.15s',
                }}
              />
            )}

            {touched[field.name] && errors[field.name] && (
              <span style={{
                fontSize: '12px',
                color: '#ef4444',
                fontWeight: '500',
              }}>
                {errors[field.name]}
              </span>
            )}
          </div>
        ))}
      </div>

      {/* Botões de ação */}
      <div style={{
        display: 'flex',
        gap: '12px',
        justifyContent: 'flex-end',
        flexWrap: 'wrap',
      }}>
        {onCancel && (
          <button
            type="button"
            onClick={onCancel}
            disabled={isSubmitting}
            style={{
              padding: '10px 16px',
              backgroundColor: 'rgba(255,255,255,0.06)',
              color: '#e8e8f0',
              border: '1px solid rgba(255,255,255,0.06)',
              borderRadius: '6px',
              cursor: isSubmitting ? 'not-allowed' : 'pointer',
              fontWeight: '600',
              transition: 'all 0.15s',
              opacity: isSubmitting ? 0.5 : 1,
            }}
          >
            {cancelLabel}
          </button>
        )}
        <button
          type="submit"
          disabled={isSubmitting}
          style={{
            padding: '10px 16px',
            backgroundColor: '#4f6ef7',
            color: 'white',
            border: 'none',
            borderRadius: '6px',
            cursor: isSubmitting ? 'not-allowed' : 'pointer',
            fontWeight: '600',
            transition: 'all 0.15s',
            opacity: isSubmitting ? 0.6 : 1,
          }}
        >
          {isSubmitting ? 'Processando...' : submitLabel}
        </button>
      </div>
    </form>
  );
});

DataForm.displayName = 'DataForm';

DataForm.propTypes = {
  fields: PropTypes.arrayOf(PropTypes.shape({
    name: PropTypes.string.isRequired,
    label: PropTypes.string,
    type: PropTypes.string,
    required: PropTypes.bool,
    placeholder: PropTypes.string,
    options: PropTypes.array,
    rows: PropTypes.number,
  })).isRequired,
  values: PropTypes.object.isRequired,
  errors: PropTypes.object,
  touched: PropTypes.object,
  isSubmitting: PropTypes.bool,
  onSubmit: PropTypes.func,
  onCancel: PropTypes.func,
  onFieldChange: PropTypes.func,
  onFieldBlur: PropTypes.func,
  submitLabel: PropTypes.string,
  cancelLabel: PropTypes.string,
  title: PropTypes.string,
};

export default DataForm;
