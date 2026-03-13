import React, { useRef, useEffect } from "react";

const FormContainer = ({ children, editTarget }) => {
  const ref = useRef(null);

  useEffect(() => {
    if (editTarget && ref.current) {
      ref.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }, [editTarget]);

  return (
    <div 
      ref={ref} 
      style={{
        marginBottom: 'var(--space-2xl)',
        padding: 'var(--space-lg)',
        backgroundColor: 'var(--color-surface)',
        borderRadius: 'var(--radius-lg)',
        border: '1px solid var(--color-border)',
        boxShadow: 'var(--shadow-sm)',
        transition: 'all var(--transition-base) ease',
      }}
    >
      {children}
    </div>
  );
};

export default FormContainer;