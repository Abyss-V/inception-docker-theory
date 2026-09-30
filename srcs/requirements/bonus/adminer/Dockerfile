FROM debian:bookworm

RUN apt-get update -y && apt-get install adminer php-cli php-mysql -y

EXPOSE 8080

CMD ["php","-S","0.0.0.0:8080","-t","/usr/share/adminer"]