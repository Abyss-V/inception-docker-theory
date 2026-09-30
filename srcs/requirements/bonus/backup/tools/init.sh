#!/bin/sh

set -e

cat > /etc/cron.d/backup-cron <<EOF
MYSQL_USER=$MYSQL_USER
MYSQL_DATABASE=$MYSQL_DATABASE

0 * * * * root /bin/sh /usr/local/bin/backup.sh
EOF

chmod 0644 /etc/cron.d/backup-cron

exec cron -f