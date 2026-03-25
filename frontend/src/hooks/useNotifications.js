import { useState, useEffect, useCallback } from "react";
import api from "../services/api";

const REFRESH_INTERVAL = 5 * 60 * 1000; // 5 minutos

export function useNotifications() {
  const [alerts, setAlerts]   = useState([]);
  const [loading, setLoading] = useState(true);
  const [lastUpdate, setLastUpdate] = useState(null);

  const fetch = useCallback(async () => {
    try {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const in7days = new Date(today);
      in7days.setDate(in7days.getDate() + 7);

      const todayStr     = today.toISOString().split("T")[0];
      const yesterdayStr = new Date(today.getTime() - 86400000).toISOString().split("T")[0];
      const in7daysStr   = in7days.toISOString().split("T")[0];

      // Busca em paralelo: resumo, marcados como vencido, e pendentes com prazo já passado
      const [summaryRes, vencidosRes, pendentesAtrasadosRes] = await Promise.all([
        api.get("/summary"),
        api.get("/financial?status=vencido"),
        api.get(`/financial?status=pendente&to=${yesterdayStr}`),
      ]);

      const summary            = summaryRes.data;
      const vencidos           = vencidosRes.data || [];
      const pendentesAtrasados = pendentesAtrasadosRes.data || [];

      // Mescla e desduplicata: vencido explícito + pendente com prazo passado
      const todosVencidos = [...vencidos];
      for (const t of pendentesAtrasados) {
        if (!todosVencidos.find((v) => v.id === t.id)) todosVencidos.push(t);
      }

      const newAlerts = [];

      // ── Estoque zerado ────────────────────────────────────────────────────
      const semEstoque = (summary.lowStock || []).filter((p) => p.quantity === 0);
      if (semEstoque.length > 0) {
        newAlerts.push({
          id:       "stock-zero",
          type:     "danger",
          category: "Estoque",
          icon:     "📦",
          title:    `${semEstoque.length} produto${semEstoque.length > 1 ? "s" : ""} sem estoque`,
          items:    semEstoque.map((p) => p.name),
          link:     "/products",
          linkLabel:"Ver produtos",
        });
      }

      // ── Estoque baixo (> 0 e ≤ 5) ─────────────────────────────────────────
      const estoqueBaixo = (summary.lowStock || []).filter((p) => p.quantity > 0 && p.quantity <= 5);
      if (estoqueBaixo.length > 0) {
        newAlerts.push({
          id:       "stock-low",
          type:     "warning",
          category: "Estoque",
          icon:     "⚠️",
          title:    `${estoqueBaixo.length} produto${estoqueBaixo.length > 1 ? "s" : ""} com estoque baixo`,
          items:    estoqueBaixo.map((p) => `${p.name} (${p.quantity} un.)`),
          link:     "/products",
          linkLabel:"Ver produtos",
        });
      }

      // ── Lançamentos vencidos (status=vencido + pendentes com prazo passado) ─
      if (todosVencidos.length > 0) {
        const totalVencido = todosVencidos.reduce((s, t) => s + Number(t.amount), 0);
        newAlerts.push({
          id:       "fin-overdue",
          type:     "danger",
          category: "Financeiro",
          icon:     "🔴",
          title:    `${todosVencidos.length} lançamento${todosVencidos.length > 1 ? "s" : ""} vencido${todosVencidos.length > 1 ? "s" : ""}`,
          subtitle: `Total: R$ ${Number(totalVencido).toFixed(2).replace(".", ",")}`,
          items:    todosVencidos.slice(0, 5).map((t) => {
            const due = t.due_date ? new Date(t.due_date).toLocaleDateString("pt-BR") : null;
            return `${t.description} — R$ ${Number(t.amount).toFixed(2).replace(".", ",")}${due ? ` (venc. ${due})` : ""}`;
          }),
          link:     "/financial",
          linkLabel:"Ver financeiro",
        });
      }

      // ── Vencendo em 7 dias (pendentes com prazo futuro) ───────────────────
      try {
        const upcomingRes = await api.get(
          `/financial?status=pendente&from=${todayStr}&to=${in7daysStr}`
        );
        const upcoming = upcomingRes.data || [];
        if (upcoming.length > 0) {
          newAlerts.push({
            id:       "fin-upcoming",
            type:     "warning",
            category: "Financeiro",
            icon:     "🟡",
            title:    `${upcoming.length} vencimento${upcoming.length > 1 ? "s" : ""} nos próximos 7 dias`,
            items:    upcoming.slice(0, 5).map((t) => {
              const due = new Date(t.due_date).toLocaleDateString("pt-BR");
              return `${t.description} — ${due}`;
            }),
            link:     "/financial",
            linkLabel:"Ver financeiro",
          });
        }
      } catch (_) { /* ignora erro isolado */ }

      setAlerts(newAlerts);
      setLastUpdate(new Date());
    } catch (_) {
      // silencioso — não quebra a UI se falhar
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetch();
    const interval = setInterval(fetch, REFRESH_INTERVAL);
    return () => clearInterval(interval);
  }, [fetch]);

  const total = alerts.reduce((s, a) => {
    // Conta só os alertas de danger para o badge vermelho
    return a.type === "danger" ? s + 1 : s;
  }, 0) + alerts.filter((a) => a.type === "warning").length;

  return { alerts, total, loading, refresh: fetch, lastUpdate };
}
