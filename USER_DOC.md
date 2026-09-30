# Inception User Documentation

## Purpose

This document explains how an end user or administrator can start, stop, access, inspect, and manage the Inception stack.

## Services Provided

The stack contains the mandatory services:

- **NGINX** — HTTPS entrypoint for WordPress on port `443`.
- **WordPress + PHP-FPM** — WordPress application runtime.
- **MariaDB** — WordPress database.

It also contains the bonus services:

- **Redis** — WordPress persistent object cache.
- **FTP** — authenticated read/write access to the WordPress website volume.
- **Static website** — independent HTML/CSS/JavaScript website on port `8081`.
- **Adminer** — browser-based MariaDB administration on port `8080`.
- **Backup** — automatic MariaDB SQL backup service.

## Starting the Project

From the repository root:

```bash
make
```

This creates the mandatory data directories, builds the images, and starts the containers in detached mode.

Check that the services are running:

```bash
make ps
```

or:

```bash
docker compose -f srcs/docker-compose.yml ps
```

## Stopping the Project

Stop containers without removing them:

```bash
make stop
```

Start stopped containers again:

```bash
make start
```

Remove containers and Compose networks while keeping persistent data:

```bash
make clean
```

Restart the running stack:

```bash
make restart
```

## Full Reset

A full reset is destructive:

```bash
make fclean
```

This removes project containers, images, Compose volumes, and `/home/ymouhib/data`.

To rebuild everything from a clean state:

```bash
make re
```

## Accessing WordPress

Website:

```text
https://ymouhib.42.fr
```

Administration panel:

```text
https://ymouhib.42.fr/wp-admin
```

The local TLS certificate is self-signed, so a browser may display a certificate warning.

## Accessing Adminer

Open:

```text
http://<VM_IP>:8080/adminer.php
```

When logging in, use:

```text
System:   MySQL
Server:   mariadb
Username: value of MYSQL_USER from srcs/.env
Password: contents of secrets/db_password.txt
Database: value of MYSQL_DATABASE from srcs/.env
```

`mariadb` is the Docker service name used as the database hostname inside the stack.

## Accessing the Static Website

Open:

```text
http://<VM_IP>:8081
```

The site is a separate HTML/CSS/JavaScript bonus service.

## Accessing FTP

FTP control port:

```text
21
```

Passive data-port range:

```text
21100-21110
```

The FTP username is defined by:

```text
FTP_USER
```

in `srcs/.env`.

The FTP password is stored in:

```text
secrets/ftp_password.txt
```

Example connection target:

```text
ftp://<VM_IP>
```

The FTP root is the WordPress website volume at `/var/www/html`, so files visible through FTP are the same files used by WordPress.

## Redis Cache

Redis is internal to the Docker stack and is not exposed to the host.

To verify WordPress is connected to Redis:

```bash
docker exec wordpress wp redis status --path=/var/www/html
```

Expected indicators include:

```text
Status: Connected
Drop-in: Valid
Disabled: No
Errors: []
```

To view the current Redis key count:

```bash
docker exec redis redis-cli DBSIZE
```

## Database Backups

The backup container periodically creates timestamped MariaDB dump files in:

```text
/backup
```

inside the backup container.

List available backups:

```bash
docker exec backup ls -lh /backup
```

Run an additional backup manually:

```bash
docker exec backup sh /usr/local/bin/backup.sh
```

The backup files are stored in the Docker named volume `backup-data`.

## Credentials

Non-confidential configuration is stored in:

```text
srcs/.env
```

Confidential passwords are stored locally in:

```text
secrets/db_password.txt
secrets/db_root_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
secrets/ftp_password.txt
```

These secret files must remain outside Git.

Do not copy passwords into `.env`, Dockerfiles, or documentation.

## Checking Service Status

List all containers:

```bash
make ps
```

View all logs:

```bash
make logs
```

View one service:

```bash
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
docker compose -f srcs/docker-compose.yml logs redis
docker compose -f srcs/docker-compose.yml logs ftp
docker compose -f srcs/docker-compose.yml logs adminer
docker compose -f srcs/docker-compose.yml logs static
docker compose -f srcs/docker-compose.yml logs backup
```

## Expected Published Ports

```text
443                  NGINX / WordPress HTTPS
21                   FTP control connection
21100-21110          FTP passive data connections
8080                 Adminer
8081                 Static website
```

The following ports stay internal to Docker:

```text
3306                 MariaDB
9000                 PHP-FPM
6379                 Redis
```

## Persistent Data

Mandatory persistent data is stored under:

```text
/home/ymouhib/data/mariadb
/home/ymouhib/data/wordpress
```

- MariaDB data survives container recreation.
- WordPress website files survive container recreation.
- NGINX reads the WordPress volume read-only.
- FTP shares the WordPress volume read/write.

The backup service uses a separate Docker named volume:

```text
backup-data
```

## Troubleshooting

If WordPress is unavailable, inspect the mandatory request path in this order:

```text
browser
  -> NGINX :443
  -> WordPress/PHP-FPM :9000
  -> MariaDB :3306
```

Commands:

```bash
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
```

If Redis caching is unavailable:

```bash
docker exec wordpress wp redis status --path=/var/www/html
docker compose -f srcs/docker-compose.yml logs redis
```

If FTP login or transfer fails:

```bash
docker compose -f srcs/docker-compose.yml logs ftp
```

If backups are missing:

```bash
docker compose -f srcs/docker-compose.yml logs backup
docker exec backup cat /etc/cron.d/backup-cron
docker exec backup ls -lh /backup
```
