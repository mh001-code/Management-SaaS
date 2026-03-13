import React, { memo } from 'react';

/**
 * Alert Component
 * Componente unificado para exibir mensagens de status
 */
const Alert = memo(({
  type = 'info',
  title = null,
  message = null,
  icon = null,
  onClose = null,
  className = '',
}) => {
  const iconMap = {
    success: '✓',
    warning: '⚠',
    danger: '✕',
    info: 'ⓘ',
  };

  return (
    <div className={`alert alert-${type} ${className}`.trim()}>
      <span style={{ fontSize: '18px', flexShrink: 0 }}>
        {icon || iconMap[type]}
      </span>
      
      <div style={{ flex: 1 }}>
        {title && (
          <strong style={{ display: 'block', marginBottom: '4px' }}>
            {title}
          </strong>
        )}
        {message && <span>{message}</span>}
      </div>
      
      {onClose && (
        <button
          onClick={onClose}
          style={{
            background: 'none',
            border: 'none',
            color: 'inherit',
            cursor: 'pointer',
            fontSize: '18px',
            padding: '0',
            opacity: 0.7,
            transition: 'opacity 150ms ease',
          }}
          onMouseEnter={(e) => e.target.style.opacity = '1'}
          onMouseLeave={(e) => e.target.style.opacity = '0.7'}
        >
          ✕
        </button>
      )}
    </div>
  );
});

Alert.displayName = 'Alert';

export default Alert;
