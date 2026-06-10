#!/usr/bin/env bash
set -euo pipefail

# Usage: PGPASSWORD=... ./apply-migrations.sh [migrations_dir]
MIGRATIONS_DIR="${1:-$(dirname "$0")}" # default to this folder
PGHOST="${PGHOST:-localhost}"
PGPORT="${PGPORT:-5432}"
PGUSER="${PGUSER:-postgres}"
PGDATABASE="${PGDATABASE:-nexo}"

if [ -z "${PGPASSWORD:-}" ]; then
  echo "Error: set PGPASSWORD environment variable before running."
  echo "Example: PGPASSWORD=secret $0"
  exit 1
fi

echo "Applying SQL migrations from: $MIGRATIONS_DIR"
for sql in "$MIGRATIONS_DIR"/*.sql; do
  [ -e "$sql" ] || continue
  echo "-- applying $sql"
  psql "host=$PGHOST port=$PGPORT user=$PGUSER dbname=$PGDATABASE" -v ON_ERROR_STOP=1 -f "$sql"
done

echo "All migrations applied."
