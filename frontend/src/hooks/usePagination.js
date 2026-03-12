import { useState, useCallback, useMemo } from 'react';

/**
 * Hook customizado para paginação
 * @param {Array} items - Array de items para paginar
 * @param {number} pageSize - Quantidade de items por página (padrão: 10)
 */
export const usePagination = (items = [], pageSize = 10) => {
  const [currentPage, setCurrentPage] = useState(1);

  const totalPages = useMemo(() => {
    return Math.ceil(items.length / pageSize);
  }, [items.length, pageSize]);

  const paginatedItems = useMemo(() => {
    const startIndex = (currentPage - 1) * pageSize;
    const endIndex = startIndex + pageSize;
    return items.slice(startIndex, endIndex);
  }, [items, currentPage, pageSize]);

  const goToPage = useCallback((page) => {
    const validPage = Math.max(1, Math.min(page, totalPages));
    setCurrentPage(validPage);
  }, [totalPages]);

  const nextPage = useCallback(() => {
    goToPage(currentPage + 1);
  }, [currentPage, goToPage]);

  const prevPage = useCallback(() => {
    goToPage(currentPage - 1);
  }, [currentPage, goToPage]);

  const resetPagination = useCallback(() => {
    setCurrentPage(1);
  }, []);

  return {
    currentPage,
    totalPages,
    paginatedItems,
    goToPage,
    nextPage,
    prevPage,
    resetPagination,
    itemsPerPage: pageSize,
    totalItems: items.length,
    hasNextPage: currentPage < totalPages,
    hasPrevPage: currentPage > 1,
  };
};
