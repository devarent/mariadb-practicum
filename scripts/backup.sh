#!/usr/bin/env sh
# Placeholder: back up the hris database with mariadb-dump.
# Replace every REPLACE_ME value before running outside this lab.
set -eu

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-REPLACE_ME}"
DB_NAME="${DB_NAME:-hris}"
OUT_FILE="${BACKUP_FILE:-./hris-backup.sql}"

echo "Placeholder backup: $DB_NAME -> $OUT_FILE"
# After setting real credentials, uncomment:
# mariadb-dump -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p \
#   --databases "$DB_NAME" --single-transaction > "$OUT_FILE"
