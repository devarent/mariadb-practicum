#!/usr/bin/env sh
# Placeholder: restore the hris database with the mariadb client.
# Replace every REPLACE_ME value before running outside this lab.
set -eu

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-REPLACE_ME}"
DB_NAME="${DB_NAME:-hris}"
SRC_FILE="${BACKUP_FILE:-./hris-backup.sql}"

echo "Placeholder restore: $SRC_FILE -> $DB_NAME"
# After setting real credentials, uncomment:
# mariadb -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p "$DB_NAME" < "$SRC_FILE"
