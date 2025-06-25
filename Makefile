COMPOSE = docker compose -f ./srcs/docker-compose.yml
ENV_SRC = /home/cogarcia/passwords/inception.env
ENV_DEST = ./srcs/.env

.PHONY: all build up down restart logs clean fclean re

all: $(ENV_DEST) build up

$(ENV_DEST): $(ENV_SRC)
	cp $(ENV_SRC) $(ENV_DEST)

build: $(ENV_DEST)
	$(COMPOSE) build

up: $(ENV_DEST)
	$(COMPOSE) up -d

down: $(ENV_DEST)
	$(COMPOSE) down -v

restart: down up

logs: $(ENV_DEST)
	$(COMPOSE) logs -f

clean: down
	@docker image prune -f

fclean: clean
	@for img in srcs-nginx srcs-mariadb srcs-wordpress; do \
		if docker image inspect $$img > /dev/null 2>&1; then \
			docker rmi $$img; \
		fi \
	done
	@for vol in srcs_wordpress srcs_mariadb; do \
		if docker volume inspect $$vol > /dev/null 2>&1; then \
			docker volume rm $$vol; \
		fi \
	done
	@docker network prune -f
	@sudo rm -rf /home/cogarcia/data/wordpress/*
	@sudo rm -rf /home/cogarcia/data/mariadb/*

re: fclean all
