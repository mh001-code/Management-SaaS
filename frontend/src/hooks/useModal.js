import { useState, useCallback } from 'react';

/**
 * Hook customizado para gerenciar estado de modais
 * @param {boolean} initialOpen - Estado inicial do modal (padrão: false)
 */
export const useModal = (initialOpen = false) => {
  const [isOpen, setIsOpen] = useState(initialOpen);
  const [data, setData] = useState(null);

  const open = useCallback((modalData = null) => {
    setData(modalData);
    setIsOpen(true);
  }, []);

  const close = useCallback(() => {
    setIsOpen(false);
    setTimeout(() => setData(null), 300); // Delay para animação
  }, []);

  const toggle = useCallback(() => {
    setIsOpen(prev => !prev);
  }, []);

  return {
    isOpen,
    data,
    open,
    close,
    toggle,
  };
};
