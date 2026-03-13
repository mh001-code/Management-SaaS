/**
 * Design System Tokens
 * Fonte única de verdade para todos os estilos do projeto
 */

export const TOKENS = {
  // ─────────────────────────────────────────────────────
  // COLORS
  // ─────────────────────────────────────────────────────
  colors: {
    // Base
    bg: '#0a0a0f',
    surface: '#111118',
    surface2: '#17171f',
    border: 'rgba(255,255,255,0.06)',
    
    // Text
    text: '#e8e8f0',
    textSecondary: 'rgba(255,255,255,0.65)',
    textMuted: 'rgba(255,255,255,0.35)',
    
    // Semantic
    primary: '#4f6ef7',
    primaryDark: '#3d52d5',
    primaryLight: '#6b82f9',
    
    secondary: '#06b6d4',
    tertiary: '#a78bfa',
    
    success: '#22c55e',
    successDark: '#16a34a',
    
    warning: '#f59e0b',
    warningDark: '#d97706',
    
    danger: '#ef4444',
    dangerDark: '#dc2626',
    
    info: '#3b82f6',
  },

  // ─────────────────────────────────────────────────────
  // TYPOGRAPHY
  // ─────────────────────────────────────────────────────
  typography: {
    fontDisplay: "'Syne', sans-serif",
    fontBody: "'DM Sans', sans-serif",
    
    // Sizes
    size: {
      xs: '11px',
      sm: '13px',
      base: '14px',
      lg: '16px',
      xl: '18px',
      '2xl': '22px',
      '3xl': '28px',
    },

    // Weights
    weight: {
      normal: 400,
      medium: 500,
      semibold: 600,
      bold: 700,
      extrabold: 800,
    },

    // Line heights
    lineHeight: {
      tight: 1.2,
      normal: 1.5,
      relaxed: 1.75,
    },
  },

  // ─────────────────────────────────────────────────────
  // SPACING
  // ─────────────────────────────────────────────────────
  spacing: {
    xs: '4px',
    sm: '8px',
    md: '12px',
    lg: '16px',
    xl: '20px',
    '2xl': '24px',
    '3xl': '28px',
    '4xl': '32px',
  },

  // ─────────────────────────────────────────────────────
  // BORDER RADIUS
  // ─────────────────────────────────────────────────────
  radius: {
    sm: '6px',
    md: '8px',
    lg: '12px',
    xl: '16px',
    full: '99999px',
  },

  // ─────────────────────────────────────────────────────
  // SHADOWS
  // ─────────────────────────────────────────────────────
  shadow: {
    sm: '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
    md: '0 4px 6px -1px rgba(0, 0, 0, 0.1)',
    lg: '0 10px 15px -3px rgba(0, 0, 0, 0.1)',
    xl: '0 20px 25px -5px rgba(0, 0, 0, 0.1)',
  },

  // ─────────────────────────────────────────────────────
  // TRANSITIONS
  // ─────────────────────────────────────────────────────
  transition: {
    fast: '150ms',
    base: '200ms',
    slow: '300ms',
    slower: '500ms',
  },

  // ─────────────────────────────────────────────────────
  // Z-INDEX
  // ─────────────────────────────────────────────────────
  zIndex: {
    hide: -1,
    auto: 0,
    base: 1,
    dropdown: 10,
    sticky: 20,
    fixed: 30,
    backdrop: 40,
    offCanvas: 50,
    modal: 100,
    popover: 110,
    tooltip: 120,
  },

  // ─────────────────────────────────────────────────────
  // BREAKPOINTS (Mobile First)
  // ─────────────────────────────────────────────────────
  breakpoints: {
    xs: '320px',
    sm: '480px',
    md: '768px',
    lg: '1024px',
    xl: '1280px',
    '2xl': '1536px',
  },
};

/**
 * CSS Variable Generator
 * Converte tokens em variáveis CSS
 */
export function generateCSSVariables(tokens) {
  let css = ':root {\n';

  // Colors
  Object.entries(tokens.colors).forEach(([key, value]) => {
    css += `  --color-${key}: ${value};\n`;
  });

  // Typography
  css += `  --font-display: ${tokens.typography.fontDisplay};\n`;
  css += `  --font-body: ${tokens.typography.fontBody};\n`;
  Object.entries(tokens.typography.size).forEach(([key, value]) => {
    css += `  --text-${key}: ${value};\n`;
  });

  // Spacing
  Object.entries(tokens.spacing).forEach(([key, value]) => {
    css += `  --space-${key}: ${value};\n`;
  });

  // Border Radius
  Object.entries(tokens.radius).forEach(([key, value]) => {
    css += `  --radius-${key}: ${value};\n`;
  });

  // Shadows
  Object.entries(tokens.shadow).forEach(([key, value]) => {
    css += `  --shadow-${key}: ${value};\n`;
  });

  // Z-Index
  Object.entries(tokens.zIndex).forEach(([key, value]) => {
    css += `  --z-${key}: ${value};\n`;
  });

  css += '}\n';
  return css;
}
