#!/bin/bash

# Par sécurité, on attend que MariaDB soit prêt (mieux que sleep 10 = un vrai check, si besoin je peux te le faire)
sleep 10

# Créer le dossier /run/php si nécessaire (sinon PHP-FPM plante)
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
else
    echo "wp-config.php déjà présent, rien à faire."
fi

# Lancer PHP-FPM au premier plan
/usr/sbin/php-fpm7.4 -F