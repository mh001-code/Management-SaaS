import React, { memo, forwardRef } from 'react';

/**
 * Input Component
 * Componente unificado de input com validação visual
 */
const Input = memo(forwardRef(({
  type = 'text',
  placeholder = '',
  value = '',
  onChange = null,
  onBlur = null,
  disabled = false,
  error = false,
  success = false,
  label = null,
  required = false,
  helper = null,
  errorMessage = null,
  className = '',
  ...props
}, ref) => {
  const statusClass = error ? 'error' : success ? 'success' : '';
  const classList = ['input', statusClass, className]
    .filter(Boolean)
    .join(' ');

  return (
    <div className="form-group">
      {label && (
        <label className={`label ${required ? 'required' : ''}`}>
          {label}
        </label>
      )}
      
      <input
        ref={ref}
        type={type}
        placeholder={placeholder}
        value={value}
        onChange={onChange}
        onBlur={onBlur}
        disabled={disabled}
        className={classList}
        {...props}
      />
      
      {errorMessage && (
        <span className="form-error">{errorMessage}</span>
      )}
      
      {helper && !errorMessage && (
        <span style={{
          fontSize: 'var(--text-xs)',
          color: 'var(--color-textMuted)',
          marginTop: 'var(--space-sm)',
        }}>
          {helper}
        </span>
      )}
    </div>
  );
}));

Input.displayName = 'Input';

export default Input;
