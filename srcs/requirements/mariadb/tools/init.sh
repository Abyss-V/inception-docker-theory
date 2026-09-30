#!/bin/sh
set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

mkdir -p /var/lib/mysql
chown mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql
fi

DB_PASSWORD="$(cat /run/secrets/db_password)"
DB_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"

cat > /run/mysqld/init.sql <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
IDENTIFIED BY '${DB_PASSWORD}';

ALTER USER '${MYSQL_USER}'@'%'
IDENTIFIED BY '${DB_PASSWORD}';

GRANT ALL PRIVILEGES
ON \`${MYSQL_DATABASE}\`.*
TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost'
IDENTIFIED BY '${DB_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF

chown mysql:mysql /run/mysqld/init.sql
chmod 600 /run/mysqld/init.sql

exec mariadbd \
    --user=mysql \
    --datadir=/var/lib/mysql \
    --init-file=/run/mysqld/init.sql