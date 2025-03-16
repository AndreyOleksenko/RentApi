#!/bin/bash
set -e

# Ожидание запуска PostgreSQL
echo "Waiting for PostgreSQL..."
until PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c '\q'; do
  sleep 1
done

echo "PostgreSQL started"
