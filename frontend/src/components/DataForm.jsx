import React, { memo, useCallback } from 'react';
import PropTypes from 'prop-types';
import Button from './ui/Button';
import Input from './ui/Input';

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
          marginBottom: 'var(--space-xl)',
          paddingBottom: 'var(--space-lg)',
          borderBottom: '1px solid var(--color-border)',
        }}>
          <h3 style={{
            fontSize: 'var(--text-lg)',
            fontWeight: '700',
            color: 'var(--color-text)',
            margin: 0,
            fontFamily: 'var(--font-display)',
          }}>
            {title}
          </h3>
        </div>
      )}

      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
        gap: 'var(--space-lg)',
        marginBottom: 'var(--space-2xl)',
      }}>
        {fields.map((field) => {
          const hasError = touched[field.name] && errors[field.name];
          
          if (field.type === 'textarea') {
            return (
              <div key={field.name}>
                <label className={`label ${field.required ? 'required' : ''}`}>
                  {field.label}
                </label>
                <textarea
                  name={field.name}
                  value={values[field.name] || ''}
                  onChange={(e) => handleChange(field.name, e.target.value)}
                  onBlur={() => handleBlur(field.name)}
                  placeholder={field.placeholder}
                  rows={field.rows || 4}
                  disabled={isSubmitting}
                  className={`textarea ${hasError ? 'error' : ''}`}
                />
                {hasError && (
                  <span className="form-error">{errors[field.name]}</span>
                )}
              </div>
            );
          }
          
          if (field.type === 'select') {
            return (
              <div key={field.name}>
                <label className={`label ${field.required ? 'required' : ''}`}>
                  {field.label}
                </label>
                <select
                  name={field.name}
                  value={values[field.name] || ''}
                  onChange={(e) => handleChange(field.name, e.target.value)}
                  onBlur={() => handleBlur(field.name)}
                  disabled={isSubmitting}
                  className={hasError ? 'error' : ''}
                  style={{
                    width: '100%',
                    padding: 'var(--space-md) var(--space-lg)',
                    backgroundColor: 'var(--color-surface2)',
                    border: hasError 
                      ? '1px solid var(--color-danger)' 
                      : '1px solid var(--color-border)',
                    borderRadius: 'var(--radius-md)',
                    color: 'var(--color-text)',
                    fontFamily: 'var(--font-body)',
                    fontSize: 'var(--text-base)',
                    cursor: isSubmitting ? 'not-allowed' : 'pointer',
                    transition: 'all 150ms ease',
                  }}
                >
                  <option value="">Selecione...</option>
                  {field.options?.map((opt) => (
                    <option key={opt.value} value={opt.value}>
                      {opt.label}
                    </option>
                  ))}
                </select>
                {hasError && (
                  <span className="form-error">{errors[field.name]}</span>
                )}
              </div>
            );
          }
          
          return (
            <Input
              key={field.name}
              type={field.type || 'text'}
              label={field.label}
              required={field.required}
              placeholder={field.placeholder}
              value={values[field.name] || ''}
              onChange={(e) => handleChange(field.name, e.target.value)}
              onBlur={() => handleBlur(field.name)}
              disabled={isSubmitting}
              error={hasError}
              errorMessage={hasError ? errors[field.name] : null}
            />
          );
        })}
      </div>

      {/* Botões de ação */}
      <div style={{
        display: 'flex',
        gap: 'var(--space-md)',
        justifyContent: 'flex-end',
        flexWrap: 'wrap',
      }}>
        {onCancel && (
          <Button
            variant="secondary"
            type="button"
            onClick={onCancel}
            disabled={isSubmitting}
          >
            {cancelLabel}
          </Button>
        )}
        <Button
          variant="primary"
          type="submit"
          disabled={isSubmitting}
        >
          {isSubmitting ? 'Processando...' : submitLabel}
        </Button>
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
