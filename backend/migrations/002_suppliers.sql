-- =============================================================================
-- migrations/002_suppliers.sql
-- =============================================================================

BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM migrations WHERE name = '002_suppliers') THEN
    RAISE NOTICE 'Migration 002_suppliers already applied, skipping.';
    RETURN;
  END IF;

  -- ── Fornecedores ────────────────────────────────────────────────────────────
  CREATE TABLE IF NOT EXISTS suppliers (
    id           SERIAL PRIMARY KEY,
    name         VARCHAR(150)   NOT NULL,
    email        VARCHAR(255)   UNIQUE,
    phone        VARCHAR(30),
    document     VARCHAR(30),              -- CNPJ / CPF
    contact_name VARCHAR(150),             -- nome do responsável
    notes        TEXT,
    created_at   TIMESTAMPTZ    NOT NULL DEFAULT NOW()
  );

  -- ── Ordens de compra ────────────────────────────────────────────────────────
  CREATE TABLE IF NOT EXISTS purchase_orders (
    id           SERIAL PRIMARY KEY,
    supplier_id  INTEGER        NOT NULL
                   REFERENCES suppliers(id) ON DELETE RESTRICT,
    user_id      INTEGER
                   REFERENCES users(id) ON DELETE SET NULL,
    total        NUMERIC(12,2)  NOT NULL DEFAULT 0 CHECK (total >= 0),
    status       VARCHAR(20)    NOT NULL DEFAULT 'pendente'
                   CHECK (status IN ('pendente','confirmado','recebido','cancelado')),
    notes        TEXT,
    created_at   TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ
  );

  -- ── Itens da ordem de compra ─────────────────────────────────────────────────
  CREATE TABLE IF NOT EXISTS purchase_order_items (
    id                SERIAL PRIMARY KEY,
    purchase_order_id INTEGER        NOT NULL
                        REFERENCES purchase_orders(id) ON DELETE CASCADE,
    product_id        INTEGER        NOT NULL
                        REFERENCES products(id) ON DELETE RESTRICT,
    quantity          INTEGER        NOT NULL CHECK (quantity > 0),
    unit_cost         NUMERIC(12,2)  NOT NULL CHECK (unit_cost >= 0)
  );

  -- ── Índices ──────────────────────────────────────────────────────────────────
  CREATE INDEX IF NOT EXISTS idx_purchase_orders_supplier ON purchase_orders(supplier_id);
  CREATE INDEX IF NOT EXISTS idx_purchase_orders_status   ON purchase_orders(status);
  CREATE INDEX IF NOT EXISTS idx_poi_order                ON purchase_order_items(purchase_order_id);

  INSERT INTO migrations (name) VALUES ('002_suppliers');
  RAISE NOTICE 'Migration 002_suppliers applied successfully.';
END;
$$ LANGUAGE plpgsql;

COMMIT;
