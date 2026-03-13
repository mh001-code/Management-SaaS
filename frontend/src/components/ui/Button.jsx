import React, { memo } from 'react';

/**
 * Button Component
 * Componente unificado de botão com todas as variantes
 */
const Button = memo(({
  children,
  variant = 'primary',
  size = 'md',
  disabled = false,
  block = false,
  type = 'button',
  onClick = null,
  className = '',
  ...props
}) => {
  const baseClass = 'btn';
  const variantClass = `btn-${variant}`;
  const sizeClass = size !== 'md' ? `btn-${size}` : '';
  const blockClass = block ? 'btn-block' : '';
  
  const classList = [baseClass, variantClass, sizeClass, blockClass, className]
    .filter(Boolean)
    .join(' ');

  return (
    <button
      type={type}
      disabled={disabled}
      onClick={onClick}
      className={classList}
      {...props}
    >
      {children}
    </button>
  );
});

Button.displayName = 'Button';

export default Button;
