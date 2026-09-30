

# Inception

## Description

Inception is a system administration project that builds a small multi-service infrastructure with Docker Compose inside a virtual machine.

The mandatory stack contains three custom-built services:

- **NGINX** — the mandatory public entrypoint, exposed on port `443` with TLS 1.2 and TLS 1.3 only.
- **WordPress + PHP-FPM** — runs WordPress and executes PHP through PHP-FPM.
- **MariaDB** — stores the WordPress database.

The bonus stack adds:

- **Redis** — persistent object cache used by WordPress.
- **FTP** — provides authenticated access to the shared WordPress website volume.
- **Static website** — a small HTML/CSS/JavaScript site served from its own container.
- **Adminer** — browser-based database administration for MariaDB.
- **Backup** — periodically creates MariaDB SQL dumps into a dedicated Docker volume.

Every service runs in its own container and is built from a project Dockerfile based on Debian.

The project domain is:

```text
ymouhib.42.fr
```

## Architecture

```text
                              HTTPS :443
Client -------------------------> NGINX
                                   |
                                   | FastCGI :9000
                                   v
                              WordPress + PHP-FPM
                               /              \
                              /                \
                 MariaDB :3306                  Redis :6379
                         |                        |
                         v                        v
                     MariaDB               object cache

FTP :21 + 21100-21110 -------> wordpress-data <------- WordPress

Browser :8080 ---------------> Adminer -----> MariaDB

Browser :8081 ---------------> Static website

Backup service --------------> MariaDB
      |
      v
 backup-data volume
```

Mandatory persistent storage:

```text
/home/ymouhib/data/mariadb
        |
        v
mariadb-data
        |
        v
/var/lib/mysql

/home/ymouhib/data/wordpress
        |
        v
wordpress-data
        |
        +--> WordPress: /var/www/html
        +--> NGINX:     /var/www/html (read-only)
        +--> FTP:       /var/www/html
```

The backup service uses a separate Docker named volume named `backup-data` mounted at `/backup` inside the backup container.

## Project Description

### Docker in this project

Docker packages each service with its filesystem, dependencies, configuration, and main runtime process. Docker Compose declares the services, network, volumes, secrets, environment variables, dependencies, and published ports required by the stack.

Ready-made application images are not used for NGINX, WordPress, MariaDB, or the bonus services. Each service is built from a Debian base image using a project Dockerfile.

The main project layout is:

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
        ├── wordpress/
        ├── nginx/
        └── bonus/
            ├── redis/
            ├── ftp/
            ├── static/
            ├── adminer/
            └── backup/
```

### Main design choices

- Debian Bookworm is used as the base distribution for all service images.
- NGINX terminates TLS and is the mandatory entrypoint for the WordPress infrastructure.
- PHP runs through PHP-FPM in the WordPress container; NGINX contains no PHP runtime.
- WordPress connects to MariaDB using the service hostname `mariadb`.
- WordPress connects to Redis using the service hostname `redis`.
- Redis is used as a cache and therefore has no dedicated persistent volume.
- FTP mounts the existing WordPress volume at `/var/www/html` so it operates directly on the website files.
- Adminer connects to MariaDB through the Docker network and is exposed on host port `8080`.
- The static website is independent from the mandatory stack and is exposed on host port `8081`.
- The backup service uses `mariadb-dump` and cron to write timestamped SQL dumps to its own named volume.
- MariaDB and WordPress initialization scripts are idempotent so existing persistent data is reused after container recreation.
- WP-CLI is used to initialize WordPress and configure the Redis object-cache integration.
- Confidential values are stored in Docker secret files rather than `.env` or Dockerfiles.
- Non-confidential configuration is stored in `srcs/.env`.

### Virtual Machines vs Docker

A virtual machine virtualizes a complete machine and normally runs its own guest kernel. Containers do not contain a separate guest kernel; their processes use the host Linux kernel while isolation is provided by kernel mechanisms such as namespaces and cgroups.

Inception uses both: Docker runs inside the virtual machine required by the subject.

| Virtual Machine | Docker Container |
|---|---|
| Runs a guest operating system and kernel | Shares the host kernel |
| Virtualizes hardware | Isolates processes and resources |
| Usually heavier to create and start | Usually lighter to create and start |
| Provides a machine-level environment | Provides a service/process-level environment |
| Used as the outer environment for Inception | Used to isolate each Inception service |

### Secrets vs Environment Variables

Environment variables are used for non-confidential configuration such as database names, usernames, the domain, WordPress metadata, and the FTP username.

Docker secrets are used for passwords. Secret files are kept locally, ignored by Git, and mounted into containers under `/run/secrets`.

| Environment Variables | Secrets |
|---|---|
| Suitable for non-confidential configuration | Suitable for confidential values |
| Become part of the process environment | Exposed to the service as files |
| Used for values such as `DOMAIN_NAME`, `MYSQL_DATABASE`, and `FTP_USER` | Used for database, WordPress, and FTP passwords |
| Loaded from `.env` through Compose | Loaded from ignored local files |

### Docker Network vs Host Network

The application services use the Compose bridge network `app_network`. Containers on that network can resolve each other by service name.

Examples:

```text
nginx     -> wordpress:9000
wordpress -> mariadb:3306
wordpress -> redis:6379
adminer   -> mariadb:3306
backup    -> mariadb:3306
```

Host networking would make a container share the host network namespace directly. It is not used in this project.

| Docker Network | Host Network |
|---|---|
| Containers have isolated network namespaces | Container shares the host network namespace |
| Service-name DNS is available | Uses host networking directly |
| Internal ports can remain unpublished | Service ports directly share host networking |
| Used by this project | Not used and forbidden by the subject |

### Docker Volumes vs Bind Mounts

A Docker named volume is a Docker-managed volume resource that survives container recreation. A bind mount directly exposes a selected host filesystem path to a container.

The mandatory MariaDB and WordPress storage is declared as Docker named volumes. The local volume driver is configured so their backing data is stored under the subject-required host path `/home/ymouhib/data`.

| Docker Named Volume | Bind Mount |
|---|---|
| Declared as a Docker volume resource | Direct host-path mount |
| Referred to by logical volume name | Coupled directly to a host path |
| Used for MariaDB, WordPress, and backup storage | Not used as the service-level declaration for mandatory persistence |
| Survives container recreation | Also persists, but is managed directly as a host path |

## Instructions

### Prerequisites

Run the project inside the Debian virtual machine used for Inception with:

- Docker Engine
- Docker Compose
- GNU Make

The domain `ymouhib.42.fr` must resolve to the virtual machine IP address.

### Configuration

Non-secret configuration is stored in:

```text
srcs/.env
```

Current variables are:

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

Passwords are stored locally in:

```text
secrets/db_password.txt
secrets/db_root_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
secrets/ftp_password.txt
```

Secret files must not be committed to Git.

### Start the project

From the repository root:

```bash
make
```

The Makefile creates the mandatory host data directories and then builds and starts the stack with Docker Compose.

### Stop the project

Stop running containers without removing them:

```bash
make stop
```

Remove containers and Compose networks while keeping persistent data:

```bash
make clean
```

### Full reset

```bash
make fclean
```

This removes containers, images, Compose volumes, and `/home/ymouhib/data`.

Rebuild everything from a clean state:

```bash
make re
```

### Check service status

```bash
make ps
```

or:

```bash
docker compose -f srcs/docker-compose.yml ps
```

### View logs

```bash
make logs
```

or for one service:

```bash
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs redis
docker compose -f srcs/docker-compose.yml logs ftp
```

## Accessing the Services

### WordPress

```text
https://ymouhib.42.fr
```

WordPress administration:

```text
https://ymouhib.42.fr/wp-admin
```

The certificate is self-signed, so a browser may display a local certificate warning.

### Adminer

```text
http://<VM_IP>:8080/adminer.php
```

Use `mariadb` as the database server name when logging in from Adminer.

### Static website

```text
http://<VM_IP>:8081
```

### FTP

Control connection:

```text
ftp://<VM_IP>:21
```

The configured passive data-port range is:

```text
21100-21110
```

The FTP username comes from `FTP_USER` in `.env`, and its password comes from `secrets/ftp_password.txt`.

## Persistence

Mandatory persistent data is stored on the VM under:

```text
/home/ymouhib/data/mariadb
/home/ymouhib/data/wordpress
```

The backup service stores SQL dumps in the Docker named volume `backup-data`, mounted at:

```text
/backup
```

inside the backup container.

## Security and Runtime Notes

- NGINX exposes the mandatory HTTPS entrypoint on port `443`.
- NGINX accepts TLS 1.2 and TLS 1.3 only.
- MariaDB `3306`, PHP-FPM `9000`, and Redis `6379` are not published to the host.
- Bonus services publish only the ports they need: FTP, Adminer `8080`, and the static site `8081`.
- Passwords are not stored in Dockerfiles or `.env`.
- No `tail -f`, `sleep infinity`, or `while true` keepalive hacks are used.
- Long-running service daemons run in the foreground as the final container process.

## Bonus Services

### Redis

WordPress uses the Redis Object Cache plugin with the PhpRedis extension. Redis is addressed as `redis:6379` over `app_network`. The cache is disposable and has no persistent volume.

Useful verification:

```bash
docker exec wordpress wp redis status --path=/var/www/html
docker exec redis redis-cli DBSIZE
```

### FTP

The FTP container uses vsftpd and mounts `wordpress-data:/var/www/html`. This allows authenticated FTP access to the same files used by WordPress.

### Static website

The static site is written with HTML, CSS, and JavaScript and is served by Python's HTTP server on port `8081`.

### Adminer

Adminer is served on port `8080` and connects to the MariaDB service over `app_network`.

### Backup service

The backup service runs cron in the foreground and periodically executes `mariadb-dump`. Timestamped SQL files are written into `/backup` on the `backup-data` named volume.

Useful verification:

```bash
docker exec backup ls -lh /backup
```

## Resources

Primary references used during the project:

- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- Docker Compose file reference: https://docs.docker.com/reference/compose-file/
- Docker volumes: https://docs.docker.com/engine/storage/volumes/
- Docker networking: https://docs.docker.com/engine/network/
- Docker secrets: https://docs.docker.com/compose/how-tos/use-secrets/
- NGINX documentation: https://nginx.org/en/docs/
- MariaDB documentation: https://mariadb.com/docs/
- PHP-FPM documentation: https://www.php.net/manual/en/install.fpm.php
- WordPress documentation: https://wordpress.org/documentation/
- WP-CLI documentation: https://wp-cli.org/
- Redis documentation: https://redis.io/docs/
- Redis Object Cache plugin: https://wordpress.org/plugins/redis-cache/
- vsftpd manual: https://manpages.debian.org/bookworm/vsftpd/vsftpd.conf.5.en.html
- Adminer: https://www.adminer.org/

### Use of AI

AI was used as a learning and review tool for:

- clarifying Docker, service, and networking behavior;
- reviewing Dockerfiles, Compose configuration, shell scripts, and service configuration;
- identifying integration and permission issues during testing;
- planning runtime verification commands;
- reviewing the final project against the Inception subject;
- helping organize project documentation.

All generated suggestions were reviewed, adapted, and tested against the actual project before being kept.
