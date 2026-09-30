#!/bin/sh
set -e
if ! id "$FTP_USER" > /dev/null 2>&1; then
    useradd -d /var/www/html -s /bin/bash -g www-data "$FTP_USER"
fi

echo "$FTP_USER:$(cat /run/secrets/ftp_password)" | chpasswd
chmod -R g+rwX /var/www/html
exec vsftpd /etc/vsftpd.conf