#!/bin/sh
set -e
if [ ! -d /var/www/html/wp-admin ];then
    wp core download --path=/var/www/html
fi

if [ ! -f /var/www/html/wp-config.php ];then
    wp config create --path=/var/www/html --dbname="$MYSQL_DATABASE" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$(cat /run/secrets/db_password)" --dbhost="mariadb" --skip-check
fi

DB_EXIST=0
for i in $(seq 1 30);do
    if  wp db query "SELECT 1;" --path=/var/www/html; then
        DB_EXIST=1
        break
    fi
    sleep 1
done

if [  "$DB_EXIST" -ne 1 ];then
    echo "MariaDB is not ready"
    exit 1
fi

if ! wp core is-installed --path="/var/www/html";then
    wp core install \
    --path=/var/www/html \
  --url="https://$DOMAIN_NAME" \
  --title="$WP_TITLE" \
  --admin_user="$WP_ADMIN_USER" \
  --admin_password="$(cat /run/secrets/wp_admin_password.txt)"\
  --admin_email="$WP_ADMIN_EMAIL"
fi
if ! wp user get "$WP_USER" --path=/var/www/html > /dev/null 2>&1;then
  wp user create "$WP_USER" "$WP_USER_EMAIL" --path=/var/www/html --role=author --user_pass="$(cat /run/secrets/wp_user_password.txt)"

fi

if ! wp plugin is-installed redis-cache --path=/var/www/html; then
    wp plugin install redis-cache --activate --path=/var/www/html
elif ! wp plugin is-active redis-cache --path=/var/www/html; then
    wp plugin activate redis-cache --path=/var/www/html
fi

wp config set WP_REDIS_HOST redis --type=constant --path=/var/www/html

if [ ! -f /var/www/html/wp-content/object-cache.php ]; then
    wp redis enable --path=/var/www/html
fi
chown -R www-data:www-data /var/www/html
chmod -R g+rwX /var/www/html
exec php-fpm8.2 -F