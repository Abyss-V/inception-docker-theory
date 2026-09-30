FROM debian:bookworm

WORKDIR /var/www/html

RUN  apt-get update -y && apt-get install openssl nginx -y

COPY conf/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /etc/nginx/ssl \
    && openssl req \
       -x509 \
       -nodes \
       -newkey rsa:2048 \
       -keyout /etc/nginx/ssl/nginx.key \
       -out /etc/nginx/ssl/nginx.crt \
       -days 365 \
       -subj "/CN=ymouhib.42.fr"

CMD ["nginx", "-g","daemon off;"]