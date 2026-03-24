-- =============================================================================
-- Management-SaaS — Database Schema (consolidated)
-- PostgreSQL >= 14
--
-- Includes: all migrations 001 → 005
-- Usage: paste into Neon SQL Editor and run
-- =============================================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================================================
-- MIGRATIONS CONTROL
-- =============================================================================
CREATE TABLE IF NOT EXISTS migrations (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(255) NOT NULL UNIQUE,
  applied_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- USERS
-- =============================================================================
CREATE TABLE IF NOT EXISTS users (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(150) NOT NULL,
  email      VARCHAR(255) NOT NULL UNIQUE,
  password   VARCHAR(255) NOT NULL,
  role       VARCHAR(20)  NOT NULL DEFAULT 'user'
               CHECK (role IN ('user', 'admin')),
  created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  CONSTRAINT users_email_check CHECK (TRIM(email) <> '')
);

-- =============================================================================
-- CLIENTS
-- =============================================================================
CREATE TABLE IF NOT EXISTS clients (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(150) NOT NULL,
  email      VARCHAR(255) UNIQUE,
  phone      VARCHAR(30),
  address    TEXT,
  created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  CONSTRAINT clients_name_check CHECK (TRIM(name) <> '')
);

-- =============================================================================
-- PRODUCTS
-- =============================================================================
CREATE TABLE IF NOT EXISTS products (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(150)   NOT NULL,
  description TEXT,
  price       NUMERIC(12, 2) NOT NULL,
  created_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  CONSTRAINT products_price_check CHECK (price > 0)
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_products_name_lower ON products (LOWER(name));

-- =============================================================================
-- STOCK
-- =============================================================================
CREATE TABLE IF NOT EXISTS stock (
  id           SERIAL PRIMARY KEY,
  product_id   INTEGER     NOT NULL UNIQUE
                 REFERENCES products(id) ON DELETE CASCADE,
  quantity     INTEGER     NOT NULL DEFAULT 0 CHECK (quantity >= 0),
  last_updated TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- SUPPLIERS
-- =============================================================================
CREATE TABLE IF NOT EXISTS suppliers (
  id           SERIAL PRIMARY KEY,
  name         VARCHAR(150) NOT NULL,
  email        VARCHAR(255) UNIQUE,
  phone        VARCHAR(30),
  document     VARCHAR(30),
  contact_name VARCHAR(150),
  notes        TEXT,
  created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- ORDERS
-- =============================================================================
CREATE TABLE IF NOT EXISTS orders (
  id         SERIAL PRIMARY KEY,
  client_id  INTEGER        NOT NULL
               REFERENCES clients(id) ON DELETE RESTRICT,
  user_id    INTEGER
               REFERENCES users(id) ON DELETE SET NULL,
  total      NUMERIC(12, 2) NOT NULL DEFAULT 0,
  status     VARCHAR(20)    NOT NULL DEFAULT 'pendente'
               CHECK (status IN (
                 'pendente', 'pago', 'enviado', 'entregue',
                 'concluído', 'cancelado', 'estornado', 'recusado'
               )),
  created_at TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ,
  CONSTRAINT orders_total_check CHECK (total > 0)
);

-- =============================================================================
-- ORDER ITEMS
-- =============================================================================
CREATE TABLE IF NOT EXISTS order_items (
  id         SERIAL PRIMARY KEY,
  order_id   INTEGER        NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id INTEGER        NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
  quantity   INTEGER        NOT NULL CHECK (quantity > 0),
  price      NUMERIC(12, 2) NOT NULL CHECK (price >= 0)
);

-- =============================================================================
-- STOCK MOVEMENTS
-- =============================================================================
CREATE TABLE IF NOT EXISTS stock_movements (
  id           SERIAL PRIMARY KEY,
  product_id   INTEGER     NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  quantity     INTEGER     NOT NULL,
  type         VARCHAR(30) NOT NULL,
  reference_id INTEGER,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- LOGS
-- =============================================================================
CREATE TABLE IF NOT EXISTS logs (
  id         SERIAL PRIMARY KEY,
  user_id    INTEGER REFERENCES users(id) ON DELETE SET NULL,
  route      VARCHAR(255),
  method     VARCHAR(10),
  status     INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- PURCHASE ORDERS
-- =============================================================================
CREATE TABLE IF NOT EXISTS purchase_orders (
  id          SERIAL PRIMARY KEY,
  supplier_id INTEGER        NOT NULL REFERENCES suppliers(id) ON DELETE RESTRICT,
  user_id     INTEGER        REFERENCES users(id) ON DELETE SET NULL,
  total       NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK (total >= 0),
  status      VARCHAR(20)    NOT NULL DEFAULT 'pendente'
                CHECK (status IN ('pendente', 'confirmado', 'recebido', 'cancelado')),
  notes       TEXT,
  created_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS purchase_order_items (
  id                SERIAL PRIMARY KEY,
  purchase_order_id INTEGER        NOT NULL REFERENCES purchase_orders(id) ON DELETE CASCADE,
  product_id        INTEGER        NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
  quantity          INTEGER        NOT NULL CHECK (quantity > 0),
  unit_cost         NUMERIC(12, 2) NOT NULL CHECK (unit_cost >= 0)
);

-- =============================================================================
-- FINANCIAL
-- =============================================================================
CREATE TABLE IF NOT EXISTS transaction_categories (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(100) NOT NULL UNIQUE,
  type       VARCHAR(10)  NOT NULL CHECK (type IN ('receita', 'despesa', 'ambos')),
  created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS transactions (
  id          SERIAL PRIMARY KEY,
  type        VARCHAR(10)    NOT NULL CHECK (type IN ('receita', 'despesa')),
  description VARCHAR(255)   NOT NULL,
  amount      NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
  due_date    DATE           NOT NULL,
  paid_date   DATE,
  status      VARCHAR(20)    NOT NULL DEFAULT 'pendente'
                CHECK (status IN ('pendente', 'pago', 'vencido', 'cancelado')),
  category_id INTEGER        REFERENCES transaction_categories(id) ON DELETE SET NULL,
  order_id    INTEGER        REFERENCES orders(id) ON DELETE SET NULL,
  client_id   INTEGER        REFERENCES clients(id) ON DELETE SET NULL,
  supplier_id INTEGER        REFERENCES suppliers(id) ON DELETE SET NULL,
  user_id     INTEGER        REFERENCES users(id) ON DELETE SET NULL,
  notes       TEXT,
  created_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ,
  CONSTRAINT transactions_dates_check CHECK (paid_date IS NULL OR paid_date >= due_date)
);

-- =============================================================================
-- INDEXES
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_orders_client_id         ON orders(client_id);
CREATE INDEX IF NOT EXISTS idx_orders_status            ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at        ON orders(created_at);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id     ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id   ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_stock_movements_product  ON stock_movements(product_id);
CREATE INDEX IF NOT EXISTS idx_logs_user_id             ON logs(user_id);
CREATE INDEX IF NOT EXISTS idx_logs_created_at          ON logs(created_at);
CREATE INDEX IF NOT EXISTS idx_purchase_orders_supplier ON purchase_orders(supplier_id);
CREATE INDEX IF NOT EXISTS idx_purchase_orders_status   ON purchase_orders(status);
CREATE INDEX IF NOT EXISTS idx_poi_order                ON purchase_order_items(purchase_order_id);
CREATE INDEX IF NOT EXISTS idx_transactions_type        ON transactions(type);
CREATE INDEX IF NOT EXISTS idx_transactions_status      ON transactions(status);
CREATE INDEX IF NOT EXISTS idx_transactions_due_date    ON transactions(due_date);
CREATE INDEX IF NOT EXISTS idx_transactions_order_id    ON transactions(order_id);
CREATE INDEX IF NOT EXISTS idx_transactions_category    ON transactions(category_id);

-- =============================================================================
-- DEFAULT DATA — transaction categories
-- =============================================================================
INSERT INTO transaction_categories (name, type) VALUES
  ('Venda de produto',  'receita'),
  ('Serviço prestado',  'receita'),
  ('Outros (receita)',  'receita'),
  ('Fornecedor',        'despesa'),
  ('Aluguel',           'despesa'),
  ('Salários',          'despesa'),
  ('Marketing',         'despesa'),
  ('Logística',         'despesa'),
  ('Impostos',          'despesa'),
  ('Manutenção',        'despesa'),
  ('Outros (despesa)',  'despesa')
ON CONFLICT (name) DO NOTHING;

-- =============================================================================
-- REGISTER MIGRATIONS AS APPLIED
-- =============================================================================
INSERT INTO migrations (name) VALUES
  ('001_initial_schema'),
  ('002_suppliers'),
  ('003_clients_address'),
  ('004_financial'),
  ('005_business_rules')
ON CONFLICT (name) DO NOTHING;
