FROM debian:bookworm

WORKDIR /var/www/html
RUN  apt-get update -y && apt-get install -y \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-redis \
    php-mbstring \
    php-xml \
    php-cli \
    php-zip \
    mariadb-client \
    curl \
    ca-certificates
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp
ENV WP_CLI_ALLOW_ROOT=1
COPY tools/init.sh /usr/local/bin/
RUN sed -i \
    's|^listen = .*|listen = 0.0.0.0:9000|' \
    /etc/php/8.2/fpm/pool.d/www.conf \
    && mkdir -p /run/php

EXPOSE 9000
CMD ["sh","/usr/local/bin/init.sh"]