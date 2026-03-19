-- =============================================================================
-- migrations/004_financial.sql
-- =============================================================================

BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM migrations WHERE name = '004_financial') THEN
    RAISE NOTICE 'Migration 004_financial already applied, skipping.';
    RETURN;
  END IF;

  -- ── Categorias de lançamento ─────────────────────────────────────────────
  CREATE TABLE IF NOT EXISTS transaction_categories (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL UNIQUE,
    type       VARCHAR(10)  NOT NULL CHECK (type IN ('receita','despesa','ambos')),
    created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
  );

  -- ── Lançamentos financeiros ──────────────────────────────────────────────
  CREATE TABLE IF NOT EXISTS transactions (
    id            SERIAL PRIMARY KEY,
    type          VARCHAR(10)    NOT NULL CHECK (type IN ('receita','despesa')),
    description   VARCHAR(255)   NOT NULL,
    amount        NUMERIC(12,2)  NOT NULL CHECK (amount > 0),
    due_date      DATE           NOT NULL,
    paid_date     DATE,
    status        VARCHAR(20)    NOT NULL DEFAULT 'pendente'
                    CHECK (status IN ('pendente','pago','vencido','cancelado')),
    category_id   INTEGER        REFERENCES transaction_categories(id) ON DELETE SET NULL,
    order_id      INTEGER        REFERENCES orders(id) ON DELETE SET NULL,
    client_id     INTEGER        REFERENCES clients(id) ON DELETE SET NULL,
    supplier_id   INTEGER        REFERENCES suppliers(id) ON DELETE SET NULL,
    user_id       INTEGER        REFERENCES users(id) ON DELETE SET NULL,
    notes         TEXT,
    created_at    TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ
  );

  CREATE INDEX IF NOT EXISTS idx_transactions_type       ON transactions(type);
  CREATE INDEX IF NOT EXISTS idx_transactions_status     ON transactions(status);
  CREATE INDEX IF NOT EXISTS idx_transactions_due_date   ON transactions(due_date);
  CREATE INDEX IF NOT EXISTS idx_transactions_order_id   ON transactions(order_id);
  CREATE INDEX IF NOT EXISTS idx_transactions_category   ON transactions(category_id);

  INSERT INTO migrations (name) VALUES ('004_financial');
  RAISE NOTICE 'Migration 004_financial applied successfully.';
END;
$$ LANGUAGE plpgsql;

-- GRANTs FORA do bloco DO $$ — rodam sempre, independente do IF acima
-- Isso garante que mesmo re-executando a migration, as permissões são aplicadas
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO saas_user;
GRANT ALL ON ALL TABLES IN SCHEMA public TO saas_user;

-- Categorias padrão — separadas do bloco para não falhar se já existirem
INSERT INTO transaction_categories (name, type) VALUES
  ('Venda de produto',   'receita'),
  ('Serviço prestado',   'receita'),
  ('Outros (receita)',   'receita'),
  ('Fornecedor',         'despesa'),
  ('Aluguel',            'despesa'),
  ('Salários',           'despesa'),
  ('Marketing',          'despesa'),
  ('Logística',          'despesa'),
  ('Impostos',           'despesa'),
  ('Manutenção',         'despesa'),
  ('Outros (despesa)',   'despesa')
ON CONFLICT (name) DO NOTHING;

COMMIT;