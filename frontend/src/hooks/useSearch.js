import { useState, useCallback, useMemo } from 'react';

/**
 * Hook customizado para busca e filtro de dados
 * @param {Array} items - Array de items para filtrar
 * @param {Array<string>} searchFields - Campos para fazer a busca
 */
export const useSearch = (items = [], searchFields = []) => {
  const [search, setSearch] = useState('');

  const handleSearchChange = useCallback((value) => {
    setSearch(value);
  }, []);

  const filtered = useMemo(() => {
    if (!search || !items.length) return items;

    const lowerSearch = search.toLowerCase();

    return items.filter(item =>
      searchFields.some(field => {
        const value = item[field];
        return value && String(value).toLowerCase().includes(lowerSearch);
      })
    );
  }, [items, search, searchFields]);

  const clearSearch = useCallback(() => {
    setSearch('');
  }, []);

  return {
    search,
    setSearch: handleSearchChange,
    filtered,
    clearSearch,
    hasSearch: search.length > 0,
  };
};
