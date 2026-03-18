-- =============================================================================
-- migrations/001_initial_schema.sql
--
-- First migration: identical to schema.sql but wrapped in a transaction
-- and registered in the migrations control table.
--
-- Runner: node scripts/migrate.js
-- =============================================================================

BEGIN;

-- Control table (created here so it exists from migration 001 onwards)
CREATE TABLE IF NOT EXISTS migrations (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(255) NOT NULL UNIQUE,
  applied_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Skip if already applied
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM migrations WHERE name = '001_initial_schema') THEN
    RAISE NOTICE 'Migration 001_initial_schema already applied, skipping.';
    RETURN;
  END IF;

  -- Extensions
  CREATE EXTENSION IF NOT EXISTS "pgcrypto";

  -- Users
  CREATE TABLE IF NOT EXISTS users (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(150)   NOT NULL,
    email       VARCHAR(255)   NOT NULL UNIQUE,
    password    VARCHAR(255)   NOT NULL,
    role        VARCHAR(20)    NOT NULL DEFAULT 'user'
                  CHECK (role IN ('user', 'admin')),
    created_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW()
  );

  -- Clients
  CREATE TABLE IF NOT EXISTS clients (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(150)   NOT NULL,
    email       VARCHAR(255)   UNIQUE,
    phone       VARCHAR(30),
    created_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW()
  );

  -- Products
  CREATE TABLE IF NOT EXISTS products (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(150)   NOT NULL,
    description TEXT,
    price       NUMERIC(12,2)  NOT NULL CHECK (price >= 0),
    created_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW()
  );

  -- Stock
  CREATE TABLE IF NOT EXISTS stock (
    id           SERIAL PRIMARY KEY,
    product_id   INTEGER        NOT NULL UNIQUE
                   REFERENCES products(id) ON DELETE CASCADE,
    quantity     INTEGER        NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    last_updated TIMESTAMPTZ    NOT NULL DEFAULT NOW()
  );

  -- Orders
  CREATE TABLE IF NOT EXISTS orders (
    id          SERIAL PRIMARY KEY,
    client_id   INTEGER        NOT NULL
                  REFERENCES clients(id) ON DELETE RESTRICT,
    user_id     INTEGER
                  REFERENCES users(id) ON DELETE SET NULL,
    total       NUMERIC(12,2)  NOT NULL DEFAULT 0 CHECK (total >= 0),
    status      VARCHAR(20)    NOT NULL DEFAULT 'pendente'
                  CHECK (status IN (
                    'pendente','pago','enviado','entregue',
                    'concluído','cancelado','estornado','recusado'
                  )),
    created_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ
  );

  -- Order items
  CREATE TABLE IF NOT EXISTS order_items (
    id          SERIAL PRIMARY KEY,
    order_id    INTEGER        NOT NULL
                  REFERENCES orders(id) ON DELETE CASCADE,
    product_id  INTEGER        NOT NULL
                  REFERENCES products(id) ON DELETE RESTRICT,
    quantity    INTEGER        NOT NULL CHECK (quantity > 0),
    price       NUMERIC(12,2)  NOT NULL CHECK (price >= 0)
  );

  -- Stock movements
  CREATE TABLE IF NOT EXISTS stock_movements (
    id           SERIAL PRIMARY KEY,
    product_id   INTEGER        NOT NULL
                   REFERENCES products(id) ON DELETE CASCADE,
    quantity     INTEGER        NOT NULL,
    type         VARCHAR(30)    NOT NULL,
    reference_id INTEGER,
    created_at   TIMESTAMPTZ    NOT NULL DEFAULT NOW()
  );

  -- Logs
  CREATE TABLE IF NOT EXISTS logs (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER
                  REFERENCES users(id) ON DELETE SET NULL,
    route       VARCHAR(255),
    method      VARCHAR(10),
    status      INTEGER,
    created_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW()
  );

  -- Indexes
  CREATE INDEX IF NOT EXISTS idx_orders_client_id        ON orders(client_id);
  CREATE INDEX IF NOT EXISTS idx_orders_status           ON orders(status);
  CREATE INDEX IF NOT EXISTS idx_orders_created_at       ON orders(created_at);
  CREATE INDEX IF NOT EXISTS idx_order_items_order_id    ON order_items(order_id);
  CREATE INDEX IF NOT EXISTS idx_order_items_product_id  ON order_items(product_id);
  CREATE INDEX IF NOT EXISTS idx_stock_movements_product ON stock_movements(product_id);
  CREATE INDEX IF NOT EXISTS idx_logs_user_id            ON logs(user_id);
  CREATE INDEX IF NOT EXISTS idx_logs_created_at         ON logs(created_at);

  INSERT INTO migrations (name) VALUES ('001_initial_schema');
  RAISE NOTICE 'Migration 001_initial_schema applied successfully.';
END;
$$ LANGUAGE plpgsql;

COMMIT;
