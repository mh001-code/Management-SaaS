import React, { useState, useMemo } from "react";
import { useFetch, useForm, usePagination } from "../hooks";
import api from "../services/api";
import notificationService from "../services/notificationService";
import errorService from "../services/errorService";
import PageShell from "../components/PageShell";
import Pagination from "../components/Pagination";
import { formatCurrency } from "../utils/formatCurrency";
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer, Legend,
} from "recharts";

const ICON_PATH = "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z";

const STATUS_STYLE = {
  pendente:  { bg: "rgba(247,145,106,0.12)", text: "#F7916A" },
  pago:      { bg: "rgba(0,212,170,0.12)",   text: "#00D4AA" },
  vencido:   { bg: "rgba(247,100,100,0.12)", text: "#F76464" },
  cancelado: { bg: "rgba(122,122,154,0.12)", text: "#7A7A9A" },
};

const TYPE_STYLE = {
  receita: { bg: "rgba(0,212,170,0.1)",   text: "#00D4AA", label: "Receita" },
  despesa: { bg: "rgba(247,100,100,0.1)", text: "#F76464", label: "Despesa" },
};

const Pill = ({ value, map }) => {
  const s = map[value] ?? { bg: "rgba(122,122,154,0.12)", text: "#7A7A9A" };
  return (
    <span style={{ padding: "3px 10px", borderRadius: 99, fontSize: 11, fontWeight: 600,
      background: s.bg, color: s.text, whiteSpace: "nowrap" }}>
      {s.label ?? value}
    </span>
  );
};

const CashFlowTooltip = ({ active, payload, label }) => {
  if (!active || !payload?.length) return null;
  return (
    <div style={{ background: "#1A1A24", border: "1px solid rgba(255,255,255,0.1)",
      borderRadius: 8, padding: "10px 14px", fontSize: 12 }}>
      <div style={{ color: "#7A7A9A", marginBottom: 6, fontWeight: 600 }}>{label}</div>
      {payload.map((p, i) => (
        <div key={i} style={{ color: p.color, fontWeight: 700, marginTop: 2 }}>
          {p.name}: {formatCurrency(p.value)}
        </div>
      ))}
    </div>
  );
};

const today = () => new Date().toISOString().split("T")[0];
const monthStart = () => new Date(new Date().getFullYear(), new Date().getMonth(), 1).toISOString().split("T")[0];

// ─── Tab: Lançamentos ─────────────────────────────────────────────────────────
const TransactionsTab = ({ categories }) => {
  const [editing, setEditing] = useState(null);
  const [filters, setFilters] = useState({ type: "", status: "" });

  const buildUrl = () => {
    const p = new URLSearchParams();
    if (filters.type)   p.set("type",   filters.type);
    if (filters.status) p.set("status", filters.status);
    return `/financial?${p.toString()}`;
  };

  const transactionUrl = buildUrl();
  const { data: transactions, loading, refetch } = useFetch(transactionUrl, true, 0);

  const { paginatedItems, currentPage, goToPage, totalPages } =
    usePagination(transactions || [], 12);

  const initialValues = {
    type:        editing?.type        ?? "despesa",
    description: editing?.description ?? "",
    amount:      editing?.amount      ?? "",
    due_date:    editing?.due_date?.split("T")[0] ?? today(),
    paid_date:   editing?.paid_date?.split("T")[0] ?? "",
    status:      editing?.status      ?? "pendente",
    category_id: editing?.category_id ?? "",
    notes:       editing?.notes       ?? "",
  };

  const { values, isSubmitting, handleSubmit, resetForm, setFieldValue } =
    useForm(initialValues, async (data) => {
      try {
        if (editing) {
          await api.put(`/financial/${editing.id}`, data);
          notificationService.success("Lançamento atualizado!");
        } else {
          await api.post("/financial", data);
          notificationService.success("Lançamento criado!");
        }
        setEditing(null);
        resetForm();
        refetch();
      } catch (err) {
        notificationService.error(errorService.handle(err, "salvar lançamento"));
      }
    });

  const handleEdit = (t) => {
    setEditing(t);
    Object.entries({
      type: t.type, description: t.description, amount: t.amount,
      due_date: t.due_date?.split("T")[0] ?? "",
      paid_date: t.paid_date?.split("T")[0] ?? "",
      status: t.status, category_id: t.category_id ?? "", notes: t.notes ?? "",
    }).forEach(([k, v]) => setFieldValue(k, v ?? ""));
  };

  const handleDelete = async (id) => {
    try {
      await api.delete(`/financial/${id}`);
      notificationService.success("Lançamento deletado!");
      refetch();
    } catch (err) {
      notificationService.error(errorService.handle(err, "deletar lançamento"));
    }
  };

  const filteredCategories = categories.filter(
    (c) => !values.type || c.type === values.type || c.type === "ambos"
  );

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 20 }}>
      {/* Formulário */}
      <div style={{ background: "var(--color-surface)", border: "1px solid var(--color-border)",
        borderRadius: 14, padding: 24 }}>
        <div style={{ fontSize: 13, fontWeight: 600, marginBottom: 18, color: "var(--color-text)" }}>
          {editing ? "✎ Editar lançamento" : "+ Novo lançamento"}
        </div>
        <form onSubmit={handleSubmit} style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: 14 }}>
          {/* Tipo */}
          <div>
            <label style={labelStyle}>Tipo *</label>
            <select style={inputStyle} value={values.type}
              onChange={(e) => { setFieldValue("type", e.target.value); setFieldValue("category_id", ""); }}>
              <option value="despesa">Despesa</option>
              <option value="receita">Receita</option>
            </select>
          </div>
          {/* Descrição */}
          <div style={{ gridColumn: "span 2" }}>
            <label style={labelStyle}>Descrição *</label>
            <input style={inputStyle} placeholder="Ex: Aluguel março" value={values.description}
              onChange={(e) => setFieldValue("description", e.target.value)} required />
          </div>
          {/* Valor */}
          <div>
            <label style={labelStyle}>Valor (R$) *</label>
            <input style={inputStyle} type="number" step="0.01" min="0.01" placeholder="0,00"
              value={values.amount} onChange={(e) => setFieldValue("amount", e.target.value)} required />
          </div>
          {/* Vencimento */}
          <div>
            <label style={labelStyle}>Vencimento *</label>
            <input style={inputStyle} type="date" value={values.due_date}
              onChange={(e) => setFieldValue("due_date", e.target.value)} required />
          </div>
          {/* Data de pagamento */}
          <div>
            <label style={labelStyle}>Data de pagamento</label>
            <input style={inputStyle} type="date" value={values.paid_date}
              onChange={(e) => setFieldValue("paid_date", e.target.value)} />
          </div>
          {/* Status */}
          <div>
            <label style={labelStyle}>Status</label>
            <select style={inputStyle} value={values.status}
              onChange={(e) => setFieldValue("status", e.target.value)}>
              <option value="pendente">Pendente</option>
              <option value="pago">Pago</option>
              <option value="vencido">Vencido</option>
              <option value="cancelado">Cancelado</option>
            </select>
          </div>
          {/* Categoria */}
          <div>
            <label style={labelStyle}>Categoria</label>
            <select style={inputStyle} value={values.category_id}
              onChange={(e) => setFieldValue("category_id", e.target.value)}>
              <option value="">Sem categoria</option>
              {filteredCategories.map((c) => (
                <option key={c.id} value={c.id}>{c.name}</option>
              ))}
            </select>
          </div>
          {/* Observações */}
          <div style={{ gridColumn: "1 / -1" }}>
            <label style={labelStyle}>Observações</label>
            <input style={inputStyle} placeholder="Opcional..." value={values.notes}
              onChange={(e) => setFieldValue("notes", e.target.value)} />
          </div>
          {/* Botões */}
          <div style={{ gridColumn: "1 / -1", display: "flex", gap: 10, justifyContent: "flex-end" }}>
            {editing && (
              <button type="button" style={btnSecondary}
                onClick={() => { setEditing(null); resetForm(); }}>
                Cancelar
              </button>
            )}
            <button type="submit" style={btnPrimary} disabled={isSubmitting}>
              {isSubmitting ? "Salvando..." : editing ? "Atualizar" : "Adicionar"}
            </button>
          </div>
        </form>
      </div>

      {/* Filtros */}
      <div style={{ display: "flex", gap: 10, flexWrap: "wrap" }}>
        <select style={{ ...inputStyle, width: "auto" }} value={filters.type}
          onChange={(e) => setFilters((p) => ({ ...p, type: e.target.value }))}>
          <option value="">Todos os tipos</option>
          <option value="receita">Receita</option>
          <option value="despesa">Despesa</option>
        </select>
        <select style={{ ...inputStyle, width: "auto" }} value={filters.status}
          onChange={(e) => setFilters((p) => ({ ...p, status: e.target.value }))}>
          <option value="">Todos os status</option>
          <option value="pendente">Pendente</option>
          <option value="pago">Pago</option>
          <option value="vencido">Vencido</option>
          <option value="cancelado">Cancelado</option>
        </select>
        <button style={btnSecondary} onClick={refetch}>Atualizar</button>
      </div>

      {/* Tabela */}
      <div style={{ background: "var(--color-surface)", border: "1px solid var(--color-border)",
        borderRadius: 14, overflow: "hidden" }}>
        <div style={{ overflowX: "auto" }}>
          <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 13 }}>
            <thead>
              <tr style={{ background: "var(--color-surface2)" }}>
                {["Tipo","Descrição","Categoria","Vencimento","Valor","Status","Ações"].map((h) => (
                  <th key={h} style={thStyle}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {loading
                ? Array.from({ length: 5 }).map((_, i) => (
                    <tr key={i} style={{ borderBottom: "1px solid var(--color-border)" }}>
                      {Array.from({ length: 7 }).map((_, j) => (
                        <td key={j} style={{ padding: "13px 16px" }}>
                          <div style={{ height: 12, borderRadius: 5, width: j === 1 ? "70%" : "50%",
                            background: "linear-gradient(90deg,#1A1A24 0%,#22223A 50%,#1A1A24 100%)",
                            backgroundSize: "200% 100%", animation: "shimmer 1.4s ease-in-out infinite" }} />
                        </td>
                      ))}
                    </tr>
                  ))
                : paginatedItems.length === 0
                ? (
                    <tr><td colSpan={7} style={{ padding: 40, textAlign: "center", color: "var(--color-textMuted)" }}>
                      Nenhum lançamento encontrado
                    </td></tr>
                  )
                : paginatedItems.map((t) => (
                    <tr key={t.id} style={{ borderBottom: "1px solid var(--color-border)",
                      transition: "background 150ms" }}
                      onMouseEnter={(e) => e.currentTarget.style.background = "rgba(124,106,247,0.04)"}
                      onMouseLeave={(e) => e.currentTarget.style.background = "transparent"}>
                      <td style={tdStyle}><Pill value={t.type} map={TYPE_STYLE} /></td>
                      <td style={tdStyle}>
                        <div style={{ fontWeight: 500 }}>{t.description}</div>
                        {t.order_id && <div style={{ fontSize: 11, color: "var(--color-textMuted)" }}>Pedido #{t.order_id}</div>}
                      </td>
                      <td style={{ ...tdStyle, color: "var(--color-textMuted)" }}>{t.category_name ?? "—"}</td>
                      <td style={{ ...tdStyle, fontFamily: "var(--font-mono)", fontSize: 12 }}>
                        {t.due_date ? new Date(t.due_date).toLocaleDateString("pt-BR") : "—"}
                      </td>
                      <td style={{ ...tdStyle, fontFamily: "var(--font-mono)", fontWeight: 600,
                        color: t.type === "receita" ? "#00D4AA" : "#F76464" }}>
                        {formatCurrency(t.amount)}
                      </td>
                      <td style={tdStyle}><Pill value={t.status} map={STATUS_STYLE} /></td>
                      <td style={{ ...tdStyle, whiteSpace: "nowrap" }}>
                        <button style={btnEdit} onClick={() => handleEdit(t)}>Editar</button>
                        <button style={btnDel}  onClick={() => handleDelete(t.id)}>Deletar</button>
                      </td>
                    </tr>
                  ))
              }
            </tbody>
          </table>
        </div>
        <div style={{ padding: "12px 20px" }}>
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} />
        </div>
      </div>
    </div>
  );
};

// ─── Tab: Fluxo de Caixa ──────────────────────────────────────────────────────
const CashFlowTab = () => {
  const [range, setRange] = useState({ from: monthStart(), to: today() });
  const [applied, setApplied] = useState({ from: monthStart(), to: today() });

  const url = `/financial/cash-flow?from=${applied.from}&to=${applied.to}`;
  const { data: cf, loading } = useFetch(url, true, 0);

  const totalReceita = cf?.totals?.find((t) => t.type === "receita")?.total ?? 0;
  const totalDespesa = cf?.totals?.find((t) => t.type === "despesa")?.total ?? 0;
  const saldo = Number(totalReceita) - Number(totalDespesa);

  const pendReceita = cf?.pending?.find((t) => t.type === "receita");
  const pendDespesa = cf?.pending?.find((t) => t.type === "despesa");

  // Monta dados para o gráfico agrupando por mês
  const chartData = useMemo(() => {
    if (!cf?.byMonth) return [];
    const map = {};
    for (const row of cf.byMonth) {
      if (!map[row.label]) map[row.label] = { label: row.label, receita: 0, despesa: 0 };
      map[row.label][row.type] = Number(row.total);
    }
    return Object.values(map);
  }, [cf]);

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 20 }}>
      {/* Filtro de período */}
      <div style={{ display: "flex", alignItems: "center", gap: 10, flexWrap: "wrap" }}>
        <span style={{ fontSize: 12, color: "var(--color-textMuted)" }}>De</span>
        <input type="date" style={inputStyle} value={range.from}
          onChange={(e) => setRange((p) => ({ ...p, from: e.target.value }))} />
        <span style={{ fontSize: 12, color: "var(--color-textMuted)" }}>até</span>
        <input type="date" style={inputStyle} value={range.to}
          onChange={(e) => setRange((p) => ({ ...p, to: e.target.value }))} />
        <button style={btnPrimary} onClick={() => setApplied(range)}>Aplicar</button>
      </div>

      {/* KPIs */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: 14 }}>
        {[
          { label: "Total receitas",  value: formatCurrency(totalReceita), color: "#00D4AA", sub: "pagas no período" },
          { label: "Total despesas",  value: formatCurrency(totalDespesa), color: "#F76464", sub: "pagas no período" },
          { label: "Saldo",           value: formatCurrency(saldo),        color: saldo >= 0 ? "#00D4AA" : "#F76464", sub: "receitas − despesas" },
        ].map((k, i) => (
          <div key={i} style={{ background: "var(--color-surface)", border: "1px solid var(--color-border)",
            borderRadius: 14, padding: "20px 22px", position: "relative", overflow: "hidden" }}>
            <div style={{ position: "absolute", top: 0, left: 0, right: 0, height: 2, background: k.color }} />
            <div style={{ fontSize: 11, fontWeight: 600, color: "var(--color-textMuted)",
              textTransform: "uppercase", letterSpacing: ".9px", marginBottom: 10 }}>{k.label}</div>
            {loading
              ? <div style={{ height: 26, width: 100, borderRadius: 6, background: "#1A1A24",
                  backgroundImage: "linear-gradient(90deg,#1A1A24 0%,#22223A 50%,#1A1A24 100%)",
                  backgroundSize: "200% 100%", animation: "shimmer 1.4s ease-in-out infinite" }} />
              : <div style={{ fontSize: 22, fontWeight: 700, fontFamily: "var(--font-mono)",
                  color: k.color, letterSpacing: "-0.5px" }}>{k.value}</div>
            }
            <div style={{ fontSize: 11, color: "var(--color-textMuted)", marginTop: 8 }}>{k.sub}</div>
          </div>
        ))}
      </div>

      {/* Pendentes */}
      {!loading && (pendReceita || pendDespesa) && (
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 14 }}>
          {pendReceita && (
            <div style={{ background: "var(--color-surface)", border: "1px solid rgba(0,212,170,0.2)",
              borderRadius: 12, padding: "16px 20px" }}>
              <div style={{ fontSize: 11, color: "#00D4AA", fontWeight: 600, textTransform: "uppercase", letterSpacing: ".8px", marginBottom: 6 }}>
                A receber (pendente)
              </div>
              <div style={{ fontSize: 18, fontWeight: 700, fontFamily: "var(--font-mono)", color: "#00D4AA" }}>
                {formatCurrency(pendReceita.total)}
              </div>
              <div style={{ fontSize: 11, color: "var(--color-textMuted)", marginTop: 4 }}>
                {pendReceita.count} lançamento{pendReceita.count > 1 ? "s" : ""}
              </div>
            </div>
          )}
          {pendDespesa && (
            <div style={{ background: "var(--color-surface)", border: "1px solid rgba(247,100,100,0.2)",
              borderRadius: 12, padding: "16px 20px" }}>
              <div style={{ fontSize: 11, color: "#F76464", fontWeight: 600, textTransform: "uppercase", letterSpacing: ".8px", marginBottom: 6 }}>
                A pagar (pendente)
              </div>
              <div style={{ fontSize: 18, fontWeight: 700, fontFamily: "var(--font-mono)", color: "#F76464" }}>
                {formatCurrency(pendDespesa.total)}
              </div>
              <div style={{ fontSize: 11, color: "var(--color-textMuted)", marginTop: 4 }}>
                {pendDespesa.count} lançamento{pendDespesa.count > 1 ? "s" : ""}
              </div>
            </div>
          )}
        </div>
      )}

      {/* Gráfico */}
      <div style={{ background: "var(--color-surface)", border: "1px solid var(--color-border)",
        borderRadius: 14, padding: 24 }}>
        <div style={{ fontSize: 13, fontWeight: 600, marginBottom: 20 }}>Receitas x Despesas por mês</div>
        {loading ? (
          <div style={{ height: 200, display: "flex", alignItems: "flex-end", gap: 12 }}>
            {[80,120,60,100,70,90].map((h, i) => (
              <div key={i} style={{ flex: 1, height: h, borderRadius: 6, background: "#1A1A24",
                backgroundImage: "linear-gradient(90deg,#1A1A24 0%,#22223A 50%,#1A1A24 100%)",
                backgroundSize: "200% 100%", animation: "shimmer 1.4s ease-in-out infinite" }} />
            ))}
          </div>
        ) : chartData.length === 0 ? (
          <div style={{ height: 200, display: "flex", alignItems: "center", justifyContent: "center",
            color: "var(--color-textMuted)", fontSize: 13 }}>
            Nenhum lançamento pago no período
          </div>
        ) : (
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={chartData} margin={{ top: 4, right: 4, bottom: 0, left: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.05)" />
              <XAxis dataKey="label" tick={{ fontSize: 11, fill: "#7A7A9A" }} />
              <YAxis tickFormatter={(v) => `R$${(v/1000).toFixed(0)}k`} tick={{ fontSize: 11, fill: "#7A7A9A" }} width={48} />
              <Tooltip content={<CashFlowTooltip />} />
              <Legend wrapperStyle={{ fontSize: 11, color: "#7A7A9A" }} />
              <Bar dataKey="receita" name="Receita" fill="#00D4AA" opacity={0.8} radius={[4,4,0,0]} />
              <Bar dataKey="despesa" name="Despesa" fill="#F76464" opacity={0.8} radius={[4,4,0,0]} />
            </BarChart>
          </ResponsiveContainer>
        )}
      </div>
    </div>
  );
};

// ─── Estilos compartilhados ───────────────────────────────────────────────────
const labelStyle = {
  display: "block", fontSize: 11, fontWeight: 600,
  color: "var(--color-textMuted)", textTransform: "uppercase",
  letterSpacing: ".7px", marginBottom: 6,
};
const inputStyle = {
  width: "100%", padding: "9px 12px",
  background: "var(--color-surface2)", border: "1px solid var(--color-border2)",
  borderRadius: 8, color: "var(--color-text)", fontFamily: "inherit",
  fontSize: 13, outline: "none",
};
const btnPrimary = {
  padding: "9px 18px", background: "var(--color-primary)", color: "#fff",
  border: "none", borderRadius: 8, fontFamily: "inherit", fontSize: 13,
  fontWeight: 600, cursor: "pointer",
};
const btnSecondary = {
  padding: "9px 16px", background: "var(--color-surface2)", color: "var(--color-text)",
  border: "1px solid var(--color-border2)", borderRadius: 8, fontFamily: "inherit",
  fontSize: 13, fontWeight: 500, cursor: "pointer",
};
const btnEdit = {
  padding: "5px 11px", background: "rgba(124,106,247,0.1)", color: "var(--color-primary)",
  border: "none", borderRadius: 7, fontSize: 12, fontWeight: 600,
  cursor: "pointer", marginRight: 6, fontFamily: "inherit",
};
const btnDel = {
  padding: "5px 11px", background: "rgba(247,100,100,0.08)", color: "var(--color-danger)",
  border: "none", borderRadius: 7, fontSize: 12, fontWeight: 600,
  cursor: "pointer", fontFamily: "inherit",
};
const thStyle = {
  padding: "11px 16px", textAlign: "left", fontSize: 11, fontWeight: 600,
  color: "var(--color-textMuted)", textTransform: "uppercase", letterSpacing: ".8px",
  borderBottom: "1px solid var(--color-border)", whiteSpace: "nowrap",
};
const tdStyle = { padding: "13px 16px", color: "var(--color-text)", verticalAlign: "middle" };

// ─── Página principal ─────────────────────────────────────────────────────────
const Financial = () => {
  const [tab, setTab] = useState("transactions");
  const { data: categories } = useFetch("/financial/categories", true, 60 * 60 * 1000);

  return (
    <div className="main-content">
      <style>{`@keyframes shimmer{0%{background-position:200% 0}100%{background-position:-200% 0}}`}</style>
      <PageShell
        title="Financeiro"
        icon={ICON_PATH}
        description="Contas a pagar, a receber e fluxo de caixa"
        actions={
          <div style={{ display: "flex", gap: 6 }}>
            {[["transactions","Lançamentos"],["cashflow","Fluxo de Caixa"]].map(([key, label]) => (
              <button key={key} onClick={() => setTab(key)} style={{
                padding: "7px 14px", borderRadius: 8, fontFamily: "inherit",
                fontSize: 12, fontWeight: 600, cursor: "pointer", border: "none",
                background: tab === key ? "var(--color-primary)" : "var(--color-surface2)",
                color: tab === key ? "#fff" : "var(--color-textMuted)",
              }}>
                {label}
              </button>
            ))}
          </div>
        }
      />
      <div className="page-body">
        {tab === "transactions"
          ? <TransactionsTab categories={categories || []} />
          : <CashFlowTab />
        }
      </div>
    </div>
  );
};

export default Financial;
