#!/bin/bash

# Start mysqld in the background for initialization
mysqld_safe --skip-networking &
pid="$!"

# Wait for the server to start
until mysqladmin ping >/dev/null 2>&1; do
    sleep 1
done

# Run initialization commands
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

# Shut down the temporary server
mysqladmin -uroot -p"${SQL_ROOT_PASSWORD}" shutdown

# Finally, start the server normally in the foreground
exec mysqld_safe
