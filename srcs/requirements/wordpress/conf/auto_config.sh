#!/bin/bash

# Wait for MariaDB to be ready
sleep 10

# Create the /run/php directory if necessary
[ -d /run/php ] || mkdir -p /run/php

cd /var/www/wordpress

echo "Wordpress : domain name = $DOMAIN_NAME"

# Download WordPress core files if they don't exist
if [ ! -f wp-load.php ]; then
    echo "Téléchargement de WordPress..."
    wp core download --allow-root
fi

# Create wp-config.php if not present
if [ ! -f wp-config.php ]; then
    echo "Création de wp-config.php..."
    wp config create --allow-root \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost="mariadb:3306"
fi

# Install WordPress if not already installed
if ! wp core is-installed --allow-root; then
    echo "Installation de WordPress..."
    wp core install --allow-root \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USR" \
        --admin_password="$WP_ADMIN_PWD" \
        --admin_email="$WP_ADMIN_EMAIL"
else
    echo "WordPress est déjà installé."
fi

wp option update siteurl "https://$DOMAIN_NAME" --allow-root
wp option update home "https://$DOMAIN_NAME" --allow-root
wp config set FORCE_SSL_ADMIN true --raw --type=constant --allow-root
wp search-replace 'http://cogarcia.42.fr' 'https://cogarcia.42.fr' --allow-root

# Start PHP-FPM
/usr/sbin/php-fpm7.4 -F
