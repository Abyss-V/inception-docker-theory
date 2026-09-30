# Inception Developer Documentation

## Purpose

This document describes how to configure, build, launch, inspect, test, and maintain the complete Inception stack from a developer perspective.

The stack contains eight custom-built services:

```text
Mandatory:
NGINX
WordPress + PHP-FPM
MariaDB

Bonus:
Redis
FTP
Static website
Adminer
Backup
```

## Prerequisites

The project must run inside a virtual machine.

The VM must provide:

- Docker Engine
- Docker Compose
- GNU Make
- Git
- the project user `ymouhib`

Verify Docker:

```bash
docker version
docker compose version
```

## Repository Layout

```text
Inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── .gitignore
├── secrets/
│   ├── db_password.txt
│   ├── db_root_password.txt
│   ├── wp_admin_password.txt
│   ├── wp_user_password.txt
│   └── ftp_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── .dockerignore
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── mariadb.cnf
        │   └── tools/
        │       └── init.sh
        ├── wordpress/
        │   ├── .dockerignore
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── www.conf
        │   └── tools/
        │       └── init.sh
        ├── nginx/
        │   ├── .dockerignore
        │   ├── Dockerfile
        │   └── conf/
        │       └── nginx.conf
        └── bonus/
            ├── redis/
            │   └── Dockerfile
            ├── ftp/
            │   ├── Dockerfile
            │   ├── conf/
            │   │   └── vsftpd.conf
            │   └── tools/
            │       └── init.sh
            ├── static/
            │   ├── Dockerfile
            │   └── public/
            │       ├── index.html
            │       ├── style.css
            │       └── script.js
            ├── adminer/
            │   └── Dockerfile
            └── backup/
                ├── Dockerfile
                └── tools/
                    ├── init.sh
                    └── backup.sh
```

## Environment Configuration

Review or create:

```text
srcs/.env
```

Current non-confidential variables are:

```env
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
WP_TITLE=title
WP_ADMIN_USER=boss
WP_ADMIN_EMAIL=boss@boss.com
WP_USER=usr
WP_USER_EMAIL=usr@email.com
DOMAIN_NAME=ymouhib.42.fr
FTP_USER=ymouhib
```

Do not place passwords in `.env`.

## Secrets

Create the local secret files before the first deployment:

```bash
mkdir -p secrets
printf '%s\n' 'database-password' > secrets/db_password.txt
printf '%s\n' 'database-root-password' > secrets/db_root_password.txt
printf '%s\n' 'wordpress-admin-password' > secrets/wp_admin_password.txt
printf '%s\n' 'wordpress-user-password' > secrets/wp_user_password.txt
printf '%s\n' 'ftp-password' > secrets/ftp_password.txt
chmod 600 secrets/*.txt
```

Required files:

```text
secrets/db_password.txt
secrets/db_root_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
secrets/ftp_password.txt
```

Verify that Git ignores them:

```bash
git check-ignore -v secrets/db_password.txt
git check-ignore -v secrets/db_root_password.txt
git check-ignore -v secrets/wp_admin_password.txt
git check-ignore -v secrets/wp_user_password.txt
git check-ignore -v secrets/ftp_password.txt
```

Verify they are not tracked:

```bash
git ls-files secrets
```

No password file should appear.

Secret usage:

```text
MariaDB:
  /run/secrets/db_password
  /run/secrets/db_root_password

WordPress:
  /run/secrets/db_password
  /run/secrets/wp_admin_password.txt
  /run/secrets/wp_user_password.txt

FTP:
  /run/secrets/ftp_password

Backup:
  /run/secrets/db_password
```

## Host Persistent-Data Directories

The mandatory volumes use host storage under:

```text
/home/ymouhib/data
```

The Makefile prepares:

```text
/home/ymouhib/data/mariadb
/home/ymouhib/data/wordpress
```

Manual setup if needed:

```bash
mkdir -p /home/ymouhib/data/mariadb
mkdir -p /home/ymouhib/data/wordpress
```

The backup service uses a normal Docker named volume named `backup-data` rather than a host directory under `/home/ymouhib/data`.

## Domain Configuration

The required project domain is:

```text
ymouhib.42.fr
```

It must resolve to the VM IP address.

For local testing, `/etc/hosts` can contain:

```text
<VM_IP> ymouhib.42.fr
```

## Building and Launching

### Validate Compose

```bash
docker compose -f srcs/docker-compose.yml config
```

### Makefile

From the repository root:

```bash
make
```

The default target calls `up`, which first creates the mandatory host data directories and then runs:

```text
docker compose -f ./srcs/docker-compose.yml up -d --build
```

### Clean rebuild

```bash
make re
```

This performs `fclean` and then rebuilds the whole project from scratch.

## Service Design

### MariaDB

Data directory:

```text
/var/lib/mysql
```

The MariaDB container uses a startup script to initialize the database only when necessary, configure the WordPress database/user from environment variables and secrets, and finally run `mariadbd` as the main process.

Persistent volume:

```text
mariadb-data -> /var/lib/mysql
```

Host backing path:

```text
/home/ymouhib/data/mariadb
```

### WordPress + PHP-FPM

Website files:

```text
/var/www/html
```

Startup behavior includes:

1. downloading WordPress when files are absent;
2. creating `wp-config.php` when absent;
3. waiting for MariaDB with bounded retries;
4. installing WordPress only when required;
5. ensuring the second WordPress user exists;
6. installing and activating the Redis Object Cache plugin;
7. setting `WP_REDIS_HOST=redis`;
8. enabling the Redis object-cache drop-in;
9. setting ownership/permissions for the shared WordPress/FTP volume;
10. executing `php-fpm8.2 -F` as the final process.

PHP-FPM listens internally on:

```text
0.0.0.0:9000
```

Persistent volume:

```text
wordpress-data -> /var/www/html
```

Host backing path:

```text
/home/ymouhib/data/wordpress
```

### NGINX

NGINX publishes:

```text
443:443
```

It:

- uses TLS 1.2 and TLS 1.3 only;
- serves the WordPress files from `/var/www/html`;
- mounts `wordpress-data` read-only;
- forwards PHP requests to `wordpress:9000` through FastCGI;
- runs in the foreground as the container's main process.

### Redis

Redis runs as a dedicated service on its default internal port:

```text
6379
```

It is not published to the host.

WordPress accesses it through:

```text
redis:6379
```

Redis is used only as a cache, so no persistent Redis volume is required.

Verify integration:

```bash
docker exec wordpress wp redis status --path=/var/www/html
docker exec redis redis-cli DBSIZE
```

### FTP

The FTP container runs vsftpd.

It mounts:

```text
wordpress-data -> /var/www/html
```

so it accesses the same files as WordPress.

Published ports:

```text
21:21
21100-21110:21100-21110
```

`vsftpd.conf` enables local users, write access, passive mode, and uses `/var/www/html` as the local root.

The init script:

1. creates the `FTP_USER` account when absent;
2. adds it to the `www-data` group;
3. sets its password from `/run/secrets/ftp_password`;
4. gives the shared WordPress files group write permission;
5. executes vsftpd as the final process.

### Static Website

The static container copies HTML/CSS/JavaScript files into:

```text
/var/www/static
```

and runs:

```text
python3 -m http.server 8081 --directory /var/www/static
```

Published port:

```text
8081:8081
```

It is independent of the mandatory application network because it does not need to communicate with the other services.

### Adminer

Adminer is served by PHP's built-in web server on:

```text
0.0.0.0:8080
```

Published port:

```text
8080:8080
```

Adminer joins `app_network` and connects to MariaDB using the hostname:

```text
mariadb
```

### Backup

The backup container installs `mariadb-client` and `cron`.

Its startup script creates a cron entry and executes:

```text
cron -f
```

as the final foreground process.

The scheduled job runs:

```text
/usr/local/bin/backup.sh
```

which executes `mariadb-dump` against `mariadb` and writes timestamped SQL files to:

```text
/backup
```

Persistent backup volume:

```text
backup-data -> /backup
```

The current cron configuration runs the backup script once per hour.

Verify backups:

```bash
docker exec backup ls -lh /backup
```

Run one manually:

```bash
docker exec backup sh /usr/local/bin/backup.sh
```

## Docker Network

The application network is:

```text
app_network
```

Services that require internal communication use service-name DNS:

```text
nginx     -> wordpress:9000
wordpress -> mariadb:3306
wordpress -> redis:6379
adminer   -> mariadb:3306
backup    -> mariadb:3306
```

FTP is also attached to `app_network`, although its main integration with WordPress is through the shared volume.

The static site is standalone and uses Compose's default network because it does not need internal service communication.

No host networking or legacy Docker links are used.

## Volumes and Persistence

Declared named volumes:

```text
mariadb-data
wordpress-data
backup-data
```

Container targets:

```text
mariadb-data:
  MariaDB -> /var/lib/mysql

wordpress-data:
  WordPress -> /var/www/html
  NGINX     -> /var/www/html (read-only)
  FTP       -> /var/www/html

backup-data:
  Backup -> /backup
```

Mandatory host backing paths:

```text
/home/ymouhib/data/mariadb
/home/ymouhib/data/wordpress
```

A normal:

```bash
make clean
```

removes containers and Compose networks but preserves persistent volume data.

## Container and Volume Management

Show state:

```bash
make ps
```

Logs:

```bash
make logs
```

Build:

```bash
docker compose -f srcs/docker-compose.yml build
```

Start:

```bash
docker compose -f srcs/docker-compose.yml up -d
```

Stop:

```bash
make stop
```

Remove containers/networks:

```bash
make clean
```

Restart:

```bash
make restart
```

Inspect volumes:

```bash
docker volume ls
docker volume inspect <volume-name>
```

Inspect networks:

```bash
docker network ls
docker network inspect <network-name>
```

## Full Reset

The project Makefile defines:

```bash
make fclean
```

which runs Compose `down -v --rmi all` and removes:

```text
/home/ymouhib/data
```

This is destructive and removes the mandatory persistent data as well as Compose volume objects.

## Runtime Verification

### Mandatory website

```bash
curl -k https://ymouhib.42.fr
```

### Redis

```bash
docker exec wordpress wp redis status --path=/var/www/html
```

### Adminer

```bash
curl -I http://localhost:8080/adminer.php
```

### Static website

```bash
curl http://localhost:8081
```

### FTP

List files:

```bash
curl --user "$FTP_USER" ftp://localhost/
```

Upload test:

```bash
echo 'ftp test' >/tmp/ftp-test.txt
curl --user "$FTP_USER" -T /tmp/ftp-test.txt ftp://localhost/ftp-test.txt
```

Verify through WordPress:

```bash
docker exec wordpress cat /var/www/html/ftp-test.txt
```

### Backup

```bash
docker exec backup ls -lh /backup
```

## Validation Checklist

```text
[ ] all service images build from project Dockerfiles
[ ] all eight containers start successfully
[ ] mandatory WordPress site works at https://ymouhib.42.fr
[ ] NGINX exposes port 443 and allows TLS 1.2 / TLS 1.3 only
[ ] MariaDB and PHP-FPM are not published to the host
[ ] Redis is connected and the WordPress object-cache drop-in is valid
[ ] FTP can authenticate and read/write the WordPress volume
[ ] Adminer loads and can connect to the WordPress database
[ ] static website responds on port 8081
[ ] backup service creates SQL dumps in backup-data
[ ] WordPress contains the required administrator and second user
[ ] administrator username respects the subject restriction
[ ] secrets are absent from Git
[ ] MariaDB data survives container recreation
[ ] WordPress files survive container recreation
[ ] mandatory data is stored under /home/ymouhib/data
[ ] no tail -f, sleep infinity, or while-true keepalive hacks are used
[ ] no host networking or legacy links are used
[ ] final daemons run in the foreground
[ ] make re succeeds from a clean state
```

## Request and Data Flow

```text
Browser
  |
  | HTTPS :443
  v
NGINX
  |
  | FastCGI :9000
  v
WordPress + PHP-FPM
  |                 \
  |                  \ Redis :6379
  v
MariaDB :3306

FTP --------------------> wordpress-data
Adminer ----------------> MariaDB
Backup -----------------> MariaDB -> backup-data
Browser :8081 ----------> static website
```
