#!/bin/bash
set -e

# Start mysqld without grant tables to allow password setup
mysqld_safe --skip-networking --skip-grant-tables &
pid="$!"

echo "etape 1"

# Wait for the server to start
until mysqladmin ping --silent; do
    sleep 1
done

echo "DATABASE : $SQL_DATABASE, USER : $SQL_USER, PASSWORD : $SQL_PASSWORD, ROOT PASS : $SQL_ROOT_PASSWORD"

# Initialize database and root password
mysql <<-EOSQL
  FLUSH PRIVILEGES;
  ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
  FLUSH PRIVILEGES;
EOSQL

echo "etape 2"

# Stop the temporary server cleanly
mysqladmin -uroot -p"${SQL_ROOT_PASSWORD}" shutdown

echo "etape 3"

# Start normal MariaDB with authentication enabled
mysqld_safe &
until mysqladmin ping --silent; do
    sleep 1
done

echo "etape 4"

# Run initialization SQL commands using authenticated root login
mysql -uroot -p"${SQL_ROOT_PASSWORD}" <<-EOSQL
  CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
  CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
  GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
  FLUSH PRIVILEGES;
EOSQL

echo "etape 5"

# Finally, start the server normally in the foreground (if Docker needs it)
echo "Initialization complete."
mysqladmin -uroot -p"${SQL_ROOT_PASSWORD}" shutdown
exec mysqld

echo "etape 6"