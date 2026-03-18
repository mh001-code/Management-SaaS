/**
 * scripts/migrate.js
 *
 * Applies all pending SQL migration files in order.
 *
 * Usage:
 *   node scripts/migrate.js
 *
 * Migration files must live in backend/migrations/ and follow the naming
 * convention: NNN_description.sql  (e.g. 001_initial_schema.sql)
 *
 * Each file is responsible for checking whether it has already been applied
 * (via the migrations table) — so this script is safe to run multiple times.
 */

import { readdir, readFile } from "fs/promises";
import { join, dirname } from "path";
import { fileURLToPath } from "url";
import pkg from "pg";
import dotenv from "dotenv";

dotenv.config();

const __dirname = dirname(fileURLToPath(import.meta.url));
const MIGRATIONS_DIR = join(__dirname, "..", "migrations");

const { Pool } = pkg;
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port: Number(process.env.DB_PORT) || 5432,
});

async function run() {
  const client = await pool.connect();

  try {
    // Read migration files sorted alphabetically (NNN_ prefix ensures order)
    const files = (await readdir(MIGRATIONS_DIR))
      .filter((f) => f.endsWith(".sql"))
      .sort();

    if (files.length === 0) {
      console.log("No migration files found in", MIGRATIONS_DIR);
      return;
    }

    console.log(`Found ${files.length} migration file(s):\n`);

    for (const file of files) {
      const filePath = join(MIGRATIONS_DIR, file);
      const sql = await readFile(filePath, "utf8");

      console.log(`▶  Applying: ${file}`);
      await client.query(sql);
      console.log(`✅ Done:     ${file}\n`);
    }

    console.log("All migrations processed.");
  } catch (err) {
    console.error("❌ Migration failed:", err.message);
    process.exit(1);
  } finally {
    client.release();
    await pool.end();
  }
}

run();
