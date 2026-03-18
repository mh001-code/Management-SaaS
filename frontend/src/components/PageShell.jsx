import React, { memo } from "react";

/**
 * PageShell
 * Cabeçalho padronizado para todas as páginas de listagem.
 *
 * Props:
 *   title       — nome da página
 *   count       — número de itens (exibe badge)
 *   icon        — SVG path string ou elemento React
 *   actions     — slot direito (inputs, selects, botões)
 *   description — subtítulo opcional
 */
const PageShell = memo(({ title, count, icon, actions, description }) => (
  <>
    <style>{`
      .ps-topbar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 20px 28px;
        border-bottom: 1px solid var(--color-border);
        flex-wrap: wrap;
        gap: 12px;
        flex-shrink: 0;
      }
      .ps-left { display: flex; align-items: center; gap: 12px; }
      .ps-icon-wrap {
        width: 38px; height: 38px; border-radius: 10px;
        background: rgba(124,106,247,0.1);
        border: 1px solid rgba(124,106,247,0.2);
        display: flex; align-items: center; justify-content: center;
        color: var(--color-primary); flex-shrink: 0;
      }
      .ps-title-group { display: flex; flex-direction: column; gap: 2px; }
      .ps-title {
        font-size: 18px; font-weight: 700; letter-spacing: -0.4px;
        color: var(--color-text); display: flex; align-items: center; gap: 8px;
      }
      .ps-count {
        font-size: 11px; font-weight: 600;
        padding: 2px 8px; border-radius: 99px;
        background: rgba(124,106,247,0.12);
        color: var(--color-primary);
        font-family: var(--font-mono);
      }
      .ps-desc { font-size: 12px; color: var(--color-textMuted); }
      .ps-actions { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
    `}</style>
    <div className="ps-topbar">
      <div className="ps-left">
        {icon && (
          <div className="ps-icon-wrap">
            {typeof icon === "string" ? (
              <svg width="18" height="18" viewBox="0 0 20 20" fill="none">
                <path d={icon} stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
              </svg>
            ) : icon}
          </div>
        )}
        <div className="ps-title-group">
          <div className="ps-title">
            {title}
            {count !== undefined && count !== null && (
              <span className="ps-count">{count}</span>
            )}
          </div>
          {description && <div className="ps-desc">{description}</div>}
        </div>
      </div>
      {actions && <div className="ps-actions">{actions}</div>}
    </div>
  </>
));

PageShell.displayName = "PageShell";
export default PageShell;
