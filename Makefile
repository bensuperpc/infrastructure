#//////////////////////////////////////////////////////////////
#//   ____                                                   //
#//  | __ )  ___ _ __  ___ _   _ _ __   ___ _ __ _ __   ___  //
#//  |  _ \ / _ \ '_ \/ __| | | | '_ \ / _ \ '__| '_ \ / __| //
#//  | |_) |  __/ | | \__ \ |_| | |_) |  __/ |  | |_) | (__  //
#//  |____/ \___|_| |_|___/\__,_| .__/ \___|_|  | .__/ \___| //
#//                             |_|             |_|          //
#//////////////////////////////////////////////////////////////
#//                                                          //
#//  Script, 2022                                            //
#//  Created: 14, April, 2022                                //
#//  Modified: 19, June, 2022                                //
#//  file: -                                                 //
#//  -                                                       //
#//  Source:                                                 //
#//  OS: ALL                                                 //
#//  CPU: ALL                                                //
#//                                                          //
#//////////////////////////////////////////////////////////////

DOCKER := docker

DISABLED_PROFILE := firefox
PROFILE := wp_db wordpress webserver certbot phpmyadmin flask_website flask_db pgadmin qbittorrent jellyfin
PROFILE_CMD := $(addprefix --profile ,$(PROFILE))

COMPOSE_FILE := docker-compose.yml

AUTHOR := bensuperpc

IMAGE_NAME := wordpress:6.1.1-php8.1-fpm mariadb:10.10.2 nginx:1.23 certbot/certbot:v1.32.0 phpmyadmin:5.2.0 dpage/pgadmin4:6.16 lscr.io/linuxserver/qbittorrent:latest \
		lscr.io/linuxserver/jellyfin:latest firefox:latest lscr.io/linuxserver/firefox:latest

#IMAGE_AUTHOR := $(addprefix itzg/, $(IMAGE_NAME))

#IMAGE_FULL_NAME := $(addsuffix :latest, $(IMAGE_AUTHOR))

.PHONY: build all
all: start

.PHONY: build
build:
	docker-compose -f $(COMPOSE_FILE) $(PROFILE_CMD) build

.PHONY: start
start:
	docker-compose -f $(COMPOSE_FILE) $(PROFILE_CMD) up -d

start-at:
	docker-compose -f $(COMPOSE_FILE) $(PROFILE_CMD) up

.PHONY: stop
stop: down

.PHONY: down
down:
	docker-compose -f $(COMPOSE_FILE) $(PROFILE_CMD) down

.PHONY: restart
restart: stop start

.PHONY: logs
logs:
	docker-compose -f $(COMPOSE_FILE) logs

.PHONY: state
state:
	docker-compose -f $(COMPOSE_FILE) ps
	docker-compose -f $(COMPOSE_FILE) top

.PHONY: update
update:
	git pull --recurse-submodules --all --progress
	echo $(IMAGE_NAME) | xargs -n1 docker pull

.PHONY: clean
clean:
	$(DOCKER) images --filter=reference='bensuperpc/*' --format='{{.Repository}}:{{.Tag}}' | xargs -r $(DOCKER) rmi -f

.PHONY: purge
purge:
	docker-compose -f $(COMPOSE_FILE) $(PROFILE_CMD) down -v --rmi all