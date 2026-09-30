FROM debian:bookworm

WORKDIR /app

RUN  apt-get update -y  &&  apt-get install mariadb-server -y
COPY conf /etc/mysql/mariadb.conf.d/

COPY tools/init.sh /usr/local/bin/

CMD ["sh","/usr/local/bin/init.sh"]