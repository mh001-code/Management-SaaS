/**
 * Formata um valor numérico como moeda brasileira (R$ 1.234,56)
 * @param {number|string} value - Valor a ser formatado
 * @param {boolean} showSymbol - Se deve mostrar o símbolo R$ (padrão: true)
 * @returns {string} Valor formatado como moeda brasileira
 */
export const formatCurrency = (value, showSymbol = true) => {
  if (value === null || value === undefined || isNaN(value)) {
    return showSymbol ? "R$ 0,00" : "0,00";
  }

  const numValue = typeof value === "string" ? parseFloat(value) : value;
  
  const formatted = new Intl.NumberFormat("pt-BR", {
    style: "currency",
    currency: "BRL",
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(numValue);

  return formatted;
};

/**
 * Formata um valor numérico como moeda brasileira sem o símbolo R$
 * @param {number|string} value - Valor a ser formatado
 * @returns {string} Valor formatado (ex: "1.234,56")
 */
export const formatCurrencyValue = (value) => {
  return formatCurrency(value, false);
};

/**
 * Converte uma string formatada em valor numérico (inverso de formatCurrency)
 * @param {string} formatted - String formatada (ex: "1.234,56")
 * @returns {number} Valor numérico
 */
export const parseCurrency = (formatted) => {
  if (typeof formatted !== "string") return 0;
  return parseFloat(formatted.replace(/\./g, "").replace(",", "."));
};
