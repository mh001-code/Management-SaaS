import React, { memo } from 'react';

/**
 * Card Component
 * Contenedor unificado com header, body e footer
 */
const Card = memo(({
  children,
  title = null,
  subtitle = null,
  footer = null,
  className = '',
}) => {
  return (
    <div className={`card ${className}`.trim()}>
      {(title || subtitle) && (
        <div className="card-header">
          {title && <div className="card-title">{title}</div>}
          {subtitle && <div className="card-subtitle">{subtitle}</div>}
        </div>
      )}
      
      <div className="card-body">
        {children}
      </div>
      
      {footer && (
        <div className="card-footer">
          {footer}
        </div>
      )}
    </div>
  );
});

Card.displayName = 'Card';

export default Card;
