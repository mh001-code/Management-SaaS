-- =============================================================================
-- migrations/003_clients_address.sql
-- =============================================================================

BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM migrations WHERE name = '003_clients_address') THEN
    RAISE NOTICE 'Migration 003_clients_address already applied, skipping.';
    RETURN;
  END IF;

  ALTER TABLE clients ADD COLUMN IF NOT EXISTS address TEXT;

  INSERT INTO migrations (name) VALUES ('003_clients_address');
  RAISE NOTICE 'Migration 003_clients_address applied successfully.';
END;
$$ LANGUAGE plpgsql;

COMMIT;
