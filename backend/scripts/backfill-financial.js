/**
 * scripts/backfill-financial.js
 *
 * Cria lançamentos de receita para todos os pedidos com status 'pago'
 * que ainda não possuem uma transação vinculada.
 *
 * Uso:
 *   node scripts/backfill-financial.js
 */

import pkg from "pg";
import dotenv from "dotenv";

dotenv.config();

const { Pool } = pkg;
const pool = new Pool({
  user:     process.env.DB_USER,
  host:     process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port:     Number(process.env.DB_PORT) || 5432,
});

async function run() {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    // Busca categoria padrão "Venda de produto"
    const catRes = await client.query(
      `SELECT id FROM transaction_categories WHERE name = 'Venda de produto' LIMIT 1`
    );
    const categoryId = catRes.rows[0]?.id ?? null;

    // Pedidos pagos, enviados, entregues ou concluídos sem lançamento vinculado
    const ordersRes = await client.query(`
      SELECT
        o.id,
        o.total,
        o.client_id,
        o.user_id,
        o.created_at,
        c.name AS client_name
      FROM orders o
      JOIN clients c ON c.id = o.client_id
      WHERE o.status IN ('pago', 'enviado', 'entregue', 'concluído')
        AND NOT EXISTS (
          SELECT 1 FROM transactions t
          WHERE t.order_id = o.id AND t.type = 'receita'
        )
      ORDER BY o.created_at
    `);

    const orders = ordersRes.rows;

    if (orders.length === 0) {
      console.log("✅ Nenhum pedido pendente de lançamento. Tudo já está sincronizado.");
      await client.query("ROLLBACK");
      return;
    }

    console.log(`📦 ${orders.length} pedido(s) encontrado(s) sem lançamento. Criando...\n`);

    let created = 0;
    for (const order of orders) {
      const dueDate  = new Date(order.created_at).toISOString().split("T")[0];
      const paidDate = dueDate; // considera pago na data do pedido

      await client.query(
        `INSERT INTO transactions
           (type, description, amount, due_date, paid_date, status,
            category_id, order_id, client_id, user_id)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`,
        [
          "receita",
          `Pedido #${order.id} — ${order.client_name}`,
          order.total,
          dueDate,
          paidDate,
          "pago",
          categoryId,
          order.id,
          order.client_id,
          order.user_id,
        ]
      );

      console.log(`  ✓ Pedido #${order.id} | ${order.client_name} | R$ ${Number(order.total).toFixed(2)}`);
      created++;
    }

    await client.query("COMMIT");
    console.log(`\n✅ ${created} lançamento(s) criado(s) com sucesso.`);
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("❌ Erro durante o backfill:", err.message);
    process.exit(1);
  } finally {
    client.release();
    await pool.end();
  }
}

run();
