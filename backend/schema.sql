-- =============================================================================
-- Management-SaaS — Database Schema
-- PostgreSQL >= 14
--
-- Usage:
--   psql -U <user> -d <database> -f schema.sql
--
-- To reset and recreate everything:
--   psql -U <user> -d <database> -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;" \
--        -f schema.sql
-- =============================================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================================================
-- USERS
-- =============================================================================
CREATE TABLE IF NOT EXISTS users (
  id           SERIAL PRIMARY KEY,
  name         VARCHAR(150)        NOT NULL,
  email        VARCHAR(255)        NOT NULL UNIQUE,
  password     VARCHAR(255)        NOT NULL,
  role         VARCHAR(20)         NOT NULL DEFAULT 'user'
                 CHECK (role IN ('user', 'admin')),
  created_at   TIMESTAMPTZ         NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- CLIENTS
-- =============================================================================
CREATE TABLE IF NOT EXISTS clients (
  id           SERIAL PRIMARY KEY,
  name         VARCHAR(150)        NOT NULL,
  email        VARCHAR(255)        UNIQUE,
  phone        VARCHAR(30),
  created_at   TIMESTAMPTZ         NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- PRODUCTS
-- =============================================================================
CREATE TABLE IF NOT EXISTS products (
  id           SERIAL PRIMARY KEY,
  name         VARCHAR(150)        NOT NULL,
  description  TEXT,
  price        NUMERIC(12, 2)      NOT NULL CHECK (price >= 0),
  created_at   TIMESTAMPTZ         NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- STOCK
-- One row per product — upserted on every stock change.
-- =============================================================================
CREATE TABLE IF NOT EXISTS stock (
  id            SERIAL PRIMARY KEY,
  product_id    INTEGER             NOT NULL UNIQUE
                  REFERENCES products(id) ON DELETE CASCADE,
  quantity      INTEGER             NOT NULL DEFAULT 0 CHECK (quantity >= 0),
  last_updated  TIMESTAMPTZ         NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- ORDERS
-- =============================================================================
CREATE TABLE IF NOT EXISTS orders (
  id           SERIAL PRIMARY KEY,
  client_id    INTEGER             NOT NULL
                 REFERENCES clients(id) ON DELETE RESTRICT,
  user_id      INTEGER
                 REFERENCES users(id) ON DELETE SET NULL,
  total        NUMERIC(12, 2)      NOT NULL DEFAULT 0 CHECK (total >= 0),
  status       VARCHAR(20)         NOT NULL DEFAULT 'pendente'
                 CHECK (status IN (
                   'pendente', 'pago', 'enviado', 'entregue',
                   'concluído', 'cancelado', 'estornado', 'recusado'
                 )),
  created_at   TIMESTAMPTZ         NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ
);

-- =============================================================================
-- ORDER ITEMS
-- =============================================================================
CREATE TABLE IF NOT EXISTS order_items (
  id           SERIAL PRIMARY KEY,
  order_id     INTEGER             NOT NULL
                 REFERENCES orders(id) ON DELETE CASCADE,
  product_id   INTEGER             NOT NULL
                 REFERENCES products(id) ON DELETE RESTRICT,
  quantity     INTEGER             NOT NULL CHECK (quantity > 0),
  price        NUMERIC(12, 2)      NOT NULL CHECK (price >= 0)
);

-- =============================================================================
-- STOCK MOVEMENTS  (audit trail — used by stockController)
-- =============================================================================
CREATE TABLE IF NOT EXISTS stock_movements (
  id           SERIAL PRIMARY KEY,
  product_id   INTEGER             NOT NULL
                 REFERENCES products(id) ON DELETE CASCADE,
  quantity     INTEGER             NOT NULL,
  type         VARCHAR(30)         NOT NULL,   -- e.g. 'entry', 'exit', 'adjustment'
  reference_id INTEGER,                        -- optional: links to order_id or similar
  created_at   TIMESTAMPTZ         NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- LOGS  (request audit — used by logMiddleware)
-- =============================================================================
CREATE TABLE IF NOT EXISTS logs (
  id           SERIAL PRIMARY KEY,
  user_id      INTEGER
                 REFERENCES users(id) ON DELETE SET NULL,
  route        VARCHAR(255),
  method       VARCHAR(10),
  status       INTEGER,
  created_at   TIMESTAMPTZ         NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- INDEXES
-- =============================================================================

-- Orders — common filters
CREATE INDEX IF NOT EXISTS idx_orders_client_id  ON orders(client_id);
CREATE INDEX IF NOT EXISTS idx_orders_status     ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);

-- Order items — joins
CREATE INDEX IF NOT EXISTS idx_order_items_order_id   ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);

-- Stock movements — product history
CREATE INDEX IF NOT EXISTS idx_stock_movements_product_id ON stock_movements(product_id);

-- Logs — filtering by user and date
CREATE INDEX IF NOT EXISTS idx_logs_user_id    ON logs(user_id);
CREATE INDEX IF NOT EXISTS idx_logs_created_at ON logs(created_at);
