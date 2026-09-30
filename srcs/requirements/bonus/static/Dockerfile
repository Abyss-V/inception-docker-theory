FROM debian:bookworm

RUN apt-get update -y && apt-get install -y python3


COPY /public /var/www/static

CMD ["python3","-m","http.server","8081","--directory","/var/www/static"]