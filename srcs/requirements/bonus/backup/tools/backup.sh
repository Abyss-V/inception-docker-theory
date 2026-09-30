#!/bin/sh
set -e
mariadb-dump -h "mariadb" -u "$MYSQL_USER" -p"$(cat /run/secrets/db_password)" "$MYSQL_DATABASE" > "/backup/backup-$(date +%Y%m%d-%H%M%S).sql"