#!/bin/bash

# Attendre que MariaDB soit prêt
sleep 10

# Créer le dossier /run/php si nécessaire
[ -d /run/php ] || mkdir -p /run/php

# Vérifier si wp-config.php existe déjà
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "wp-config.php non trouvé, création du fichier..."
    wp config create --allow-root \
                     --dbname="$SQL_DATABASE" \
                     --dbuser="$SQL_USER" \
                     --dbpass="$SQL_PASSWORD" \
                     --dbhost="mariadb:3306" \
                     --path="/var/www/wordpress"
    wp core download --allow-root
    wp core install --skip-email \
                    --allow-root \
                    --url="$DOMAIN_NAME" \
                    --title="$WP_TITLE" \
                    --admin_user="$WP_ADMIN_USR" \
                    --admin_password="$WP_ADMIN_PWD" \
                    --admin_email="$WP_ADMIN_EMAIL"
else
    echo "wp-config.php déjà présent, rien à faire."
fi

# Lancer PHP-FPM au premier plan
/usr/sbin/php-fpm7.4 -F