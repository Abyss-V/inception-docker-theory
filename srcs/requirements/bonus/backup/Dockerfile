FROM debian:bookworm

RUN apt-get update -y && apt-get install mariadb-client cron -y
COPY tools/backup.sh /usr/local/bin/backup.sh
COPY tools/init.sh  /usr/local/bin/init.sh
CMD ["sh","/usr/local/bin/init.sh"]