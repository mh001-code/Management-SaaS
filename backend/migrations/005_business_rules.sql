-- =============================================================================
-- migrations/005_business_rules.sql
-- Constraints de regras de negócio adicionais
-- =============================================================================

BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM migrations WHERE name = '005_business_rules') THEN
    RAISE NOTICE 'Migration 005_business_rules already applied, skipping.';
    RETURN;
  END IF;

  -- ── Produtos ────────────────────────────────────────────────────────────────

  -- Remove duplicatas de nome mantendo o registro mais antigo (menor id)
  DELETE FROM products
  WHERE id NOT IN (
    SELECT MIN(id) FROM products GROUP BY LOWER(name)
  );

  -- Preço deve ser maior que zero
  ALTER TABLE products DROP CONSTRAINT IF EXISTS products_price_check;
  ALTER TABLE products ADD CONSTRAINT products_price_check CHECK (price > 0);

  -- Nome único (case-insensitive) — agora sem duplicatas no banco
  DROP INDEX IF EXISTS idx_products_name_lower;
  CREATE UNIQUE INDEX idx_products_name_lower ON products (LOWER(name));

  -- ── Pedidos ─────────────────────────────────────────────────────────────────

  -- Total deve ser maior que zero
  -- (pedidos existentes com total = 0 são recalculados primeiro)
  UPDATE orders SET total = (
    SELECT COALESCE(SUM(oi.quantity * oi.price), 0.01)
    FROM order_items oi WHERE oi.order_id = orders.id
  ) WHERE total = 0;

  ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_total_check;
  ALTER TABLE orders ADD CONSTRAINT orders_total_check CHECK (total > 0);

  -- ── Financeiro ──────────────────────────────────────────────────────────────

  -- paid_date não pode ser anterior a due_date
  -- Corrige inconsistências existentes antes de adicionar a constraint
  UPDATE transactions
  SET paid_date = due_date
  WHERE paid_date IS NOT NULL AND paid_date < due_date;

  ALTER TABLE transactions DROP CONSTRAINT IF EXISTS transactions_dates_check;
  ALTER TABLE transactions
    ADD CONSTRAINT transactions_dates_check
    CHECK (paid_date IS NULL OR paid_date >= due_date);

  -- ── Clientes ─────────────────────────────────────────────────────────────────
  ALTER TABLE clients DROP CONSTRAINT IF EXISTS clients_name_check;
  ALTER TABLE clients ADD CONSTRAINT clients_name_check CHECK (TRIM(name) <> '');

  -- ── Usuários ─────────────────────────────────────────────────────────────────
  ALTER TABLE users DROP CONSTRAINT IF EXISTS users_email_check;
  ALTER TABLE users ADD CONSTRAINT users_email_check CHECK (TRIM(email) <> '');

  INSERT INTO migrations (name) VALUES ('005_business_rules');
  RAISE NOTICE 'Migration 005_business_rules applied successfully.';
END;
$$ LANGUAGE plpgsql;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO saas_user;
GRANT ALL ON ALL TABLES IN SCHEMA public TO saas_user;

COMMIT;