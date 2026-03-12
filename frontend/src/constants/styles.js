/**
 * Estilos globais centralizados para o dashboard
 * Evita duplicação de código CSS em múltiplas páginas
 */
export const GLOBAL_STYLES = `
  @import url('https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:ital,wght@0,300;0,400;0,500;1,400&display=swap');

  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --bg: #0a0a0f;
    --surface: #111118;
    --surface2: #17171f;
    --border: rgba(255,255,255,0.06);
    --text: #e8e8f0;
    --muted: rgba(255,255,255,0.35);
    --accent: #4f6ef7;
    --accent2: #06b6d4;
    --accent3: #a78bfa;
    --danger: #ef4444;
    --success: #22c55e;
    --warning: #f59e0b;
    --font-display: 'Syne', sans-serif;
    --font-body: 'DM Sans', sans-serif;
    --radius: 12px;
    --radius-sm: 8px;
  }

  body { background: var(--bg); color: var(--text); font-family: var(--font-body); }

  /* Scrollbar */
  ::-webkit-scrollbar { width: 5px; }
  ::-webkit-scrollbar-track { background: transparent; }
  ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 99px; }

  /* Animations */
  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(16px); }
    to { opacity: 1; transform: translateY(0); }
  }
  @keyframes spin { to { transform: rotate(360deg); } }
  @keyframes pulse { 0%,100% { opacity: 1; } 50% { opacity: 0.4; } }

  .fade-up { animation: fadeUp 0.45s cubic-bezier(0.22,1,0.36,1) both; }
  .fade-up-1 { animation-delay: 0.05s; }
  .fade-up-2 { animation-delay: 0.1s; }
  .fade-up-3 { animation-delay: 0.15s; }
  .fade-up-4 { animation-delay: 0.2s; }
  .fade-up-5 { animation-delay: 0.25s; }

  /* Layout */
  .dash-layout { display: flex; min-height: 100vh; }

  /* Sidebar */
  .sidebar {
    width: 220px;
    flex-shrink: 0;
    background: var(--surface);
    border-right: 1px solid var(--border);
    display: flex;
    flex-direction: column;
    padding: 24px 0;
    position: sticky;
    top: 0;
    height: 100vh;
    overflow-y: auto;
  }
  @media (max-width: 768px) { .sidebar { display: none; } }

  .sidebar-logo {
    font-family: var(--font-display);
    font-size: 18px;
    font-weight: 800;
    color: var(--text);
    padding: 0 20px 24px;
    display: flex;
    align-items: center;
    gap: 8px;
    border-bottom: 1px solid var(--border);
  }
  .logo-badge {
    width: 28px; height: 28px;
    background: var(--accent);
    border-radius: 8px;
    display: flex; align-items: center; justify-content: center;
    font-size: 14px;
    font-weight: 800;
    color: #fff;
    flex-shrink: 0;
  }

  .nav-section {
    padding: 16px 12px 8px;
    font-size: 10px;
    text-transform: uppercase;
    letter-spacing: 1.5px;
    color: var(--muted);
    font-weight: 600;
  }

  .nav-link {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 20px;
    color: var(--muted);
    font-size: 14px;
    font-weight: 500;
    text-decoration: none;
    border-radius: 0;
    transition: color 0.15s, background 0.15s;
    cursor: pointer;
    border: none;
    background: none;
    width: 100%;
    text-align: left;
  }
  .nav-link:hover { color: var(--text); background: rgba(255,255,255,0.04); }
  .nav-link.active { color: var(--accent); background: rgba(79,110,247,0.08); border-left: 2px solid var(--accent); padding-left: 18px; }
  .nav-link-icon { font-size: 16px; width: 20px; text-align: center; }

  .sidebar-bottom {
    margin-top: auto;
    padding: 16px;
    border-top: 1px solid var(--border);
  }
  .user-chip {
    display: flex; align-items: center; gap: 10px;
  }
  .user-avatar {
    width: 32px; height: 32px;
    background: var(--accent);
    border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-size: 13px;
    font-weight: 700;
    color: #fff;
    flex-shrink: 0;
  }
  .user-info { min-width: 0; }
  .user-name { font-size: 13px; font-weight: 500; color: var(--text); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .user-role { font-size: 11px; color: var(--muted); }

  /* Main content */
  .main-content {
    flex: 1;
    min-width: 0;
    background: var(--bg);
    display: flex;
    flex-direction: column;
  }

  /* Top bar */
  .topbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 20px 28px;
    border-bottom: 1px solid var(--border);
    background: var(--bg);
    position: sticky;
    top: 0;
    z-index: 10;
    gap: 16px;
  }

  .topbar-title {
    font-family: var(--font-display);
    font-size: 22px;
    font-weight: 800;
    color: var(--text);
  }

  .topbar-right {
    display: flex;
    align-items: center;
    gap: 12px;
  }

  /* Date filter */
  .date-filter {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
  }
  .date-label {
    font-size: 12px;
    color: var(--muted);
    font-weight: 500;
    white-space: nowrap;
  }
  .date-input {
    padding: 8px 12px;
    background: var(--surface2);
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    color: var(--text);
    font-size: 14px;
  }
  .date-input::placeholder { color: var(--muted); }
  .date-input:focus { outline: none; border-color: var(--accent); }

  /* Page body */
  .page-body {
    flex: 1;
    padding: 20px 28px;
    display: flex;
    flex-direction: column;
    gap: 20px;
    overflow-y: auto;
    animation: fadeUp 0.5s ease-out;
  }

  /* Card styles */
  .form-card, .chart-card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 24px;
  }

  .form-card { animation: fadeUp 0.4s cubic-bezier(0.22,1,0.36,1) 0.05s both; }
  .chart-card { animation: fadeUp 0.4s cubic-bezier(0.22,1,0.36,1) 0.1s both; }

  .form-title-sm {
    font-family: var(--font-display);
    font-size: 16px;
    font-weight: 700;
    color: var(--text);
    margin-bottom: 16px;
  }

  .chart-title {
    font-family: var(--font-display);
    font-size: 18px;
    font-weight: 700;
    color: var(--text);
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
  }

  /* Badge */
  .badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 4px 10px;
    background: rgba(255,255,255,0.1);
    border-radius: 99px;
    font-size: 12px;
    font-weight: 600;
    color: var(--text);
  }
  .badge-blue { background: rgba(79,110,247,0.2); color: var(--accent); }
  .badge-cyan { background: rgba(6,182,212,0.2); color: var(--accent2); }
  .badge-purple { background: rgba(167,139,250,0.2); color: var(--accent3); }
  .badge-success { background: rgba(34,197,94,0.2); color: var(--success); }
  .badge-danger { background: rgba(239,68,68,0.2); color: var(--danger); }

  /* Loading & Empty States */
  .loading-center {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 12px;
    padding: 40px;
  }
  .spinner-ring {
    width: 40px;
    height: 40px;
    border: 3px solid rgba(255,255,255,0.1);
    border-top-color: var(--accent);
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }

  .empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 60px 20px;
    text-align: center;
  }
  .empty-state-icon {
    font-size: 48px;
    margin-bottom: 12px;
    opacity: 0.5;
  }
  .empty-state-text {
    color: var(--muted);
    font-size: 14px;
  }

  /* Form */
  .form-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
    margin-bottom: 16px;
  }
  .form-label {
    font-size: 13px;
    font-weight: 600;
    color: var(--text);
  }
  .form-input, .form-select, .form-textarea {
    padding: 10px 12px;
    background: var(--surface2);
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    color: var(--text);
    font-family: var(--font-body);
    font-size: 14px;
    transition: border-color 0.15s;
  }
  .form-input:focus, .form-select:focus, .form-textarea:focus {
    outline: none;
    border-color: var(--accent);
  }
  .form-input::placeholder { color: var(--muted); }

  .form-button {
    padding: 10px 16px;
    background: var(--accent);
    color: white;
    border: none;
    border-radius: var(--radius-sm);
    font-weight: 600;
    cursor: pointer;
    transition: background 0.15s, transform 0.15s;
  }
  .form-button:hover { background: #3d52d5; transform: translateY(-1px); }
  .form-button:disabled { opacity: 0.5; cursor: not-allowed; }

  /* Mobile */
  @media (max-width: 768px) {
    .topbar {
      padding: 16px;
      flex-wrap: wrap;
    }
    .topbar-title {
      font-size: 18px;
    }
    .page-body {
      padding: 16px;
    }
    .form-card, .chart-card {
      padding: 16px;
    }
  }
`;

/**
 * Configuração de cores para gráficos
 */
export const CHART_COLORS = ['#4f6ef7', '#06b6d4', '#a78bfa', '#f59e0b'];

/**
 * Estilos inline para componentes específicos
 */
export const COMPONENT_STYLES = {
  button: {
    primary: 'bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition',
    secondary: 'bg-gray-300 text-gray-800 px-4 py-2 rounded hover:bg-gray-400 transition',
    danger: 'bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 transition',
    small: 'px-2 py-1 text-sm rounded',
  },
  input: {
    base: 'w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500',
    error: 'border-red-500',
  },
};
