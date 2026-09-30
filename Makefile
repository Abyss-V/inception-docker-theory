compose = docker compose -f ./srcs/docker-compose.yml

DATA_DIR = /home/ymouhib/data
WORDPRESS_DIR = $(DATA_DIR)/wordpress
MARIADB_DIR = $(DATA_DIR)/mariadb

all: up

prepare:
	mkdir -p $(WORDPRESS_DIR)
	mkdir -p $(MARIADB_DIR)

up:	prepare
	$(compose) up -d --build

logs:
	$(compose) logs -f

ps:
	$(compose) ps

start:
	$(compose) start

stop:
	$(compose) stop

restart:
	$(compose) restart

clean:
	$(compose) down

fclean:
	$(compose) down -v --rmi all
	sudo rm -rf $(DATA_DIR)

re: fclean all

.PHONY: re all ps logs start up prepare stop restart clean fclean



