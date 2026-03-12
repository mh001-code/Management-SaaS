import { useState, useEffect, useRef, useCallback } from 'react';
import api from '../services/api';

/**
 * Hook customizado para fetch com cache automático
 * @param {string} url - URL do endpoint
 * @param {boolean} immediate - Carregar imediatamente (padrão: true)
 * @param {number} cacheTime - Tempo de cache em ms (padrão: 5 minutos)
 */
export const useFetch = (url, immediate = true, cacheTime = 5 * 60 * 1000) => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const cacheRef = useRef(new Map());
  const timestampRef = useRef(new Map());

  const fetchData = useCallback(async () => {
    if (!url) return;

    // Verificar cache
    const now = Date.now();
    const cachedData = cacheRef.current.get(url);
    const cachedTime = timestampRef.current.get(url);

    if (cachedData && cachedTime && now - cachedTime < cacheTime) {
      setData(cachedData);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const response = await api.get(url);
      setData(response.data);
      cacheRef.current.set(url, response.data);
      timestampRef.current.set(url, now);
    } catch (err) {
      const errorMsg = err.response?.data?.message || err.message || 'Erro ao buscar dados';
      setError(errorMsg);
      console.error(`Fetch Error (${url}):`, errorMsg);
    } finally {
      setLoading(false);
    }
  }, [url, cacheTime]);

  useEffect(() => {
    if (immediate) {
      fetchData();
    }
  }, [url, immediate, fetchData]);

  const refetch = useCallback(() => {
    cacheRef.current.delete(url);
    timestampRef.current.delete(url);
    return fetchData();
  }, [url, fetchData]);

  const clearCache = useCallback(() => {
    cacheRef.current.clear();
    timestampRef.current.clear();
  }, []);

  return { data, loading, error, refetch, clearCache };
};
