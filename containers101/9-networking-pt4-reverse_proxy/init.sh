#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER docker;
    CREATE DATABASE photos;
    GRANT ALL PRIVILEGES ON DATABASE photos TO docker;
    CREATE TABLE IF NOT EXISTS public.images (date text, image_name text, category text);
EOSQL

psql -v ON_ERROR_STOP=1 --username "docker" --pwd="test" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE TABLE IF NOT EXISTS public.images (date text, image_name text, category text);
EOSQL