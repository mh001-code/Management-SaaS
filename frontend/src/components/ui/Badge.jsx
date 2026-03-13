import React, { memo } from 'react';

/**
 * Badge Component
 * Componente para exibir status ou labels
 */
const Badge = memo(({
  children,
  variant = 'primary',
  className = '',
  ...props
}) => {
  const classList = ['badge', `badge-${variant}`, className]
    .filter(Boolean)
    .join(' ');

  return (
    <span className={classList} {...props}>
      {children}
    </span>
  );
});

Badge.displayName = 'Badge';

export default Badge;
