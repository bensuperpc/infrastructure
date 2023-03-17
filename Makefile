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
#//  Modified: 17, March, 2023                               //
#//  file: -                                                 //
#//  -                                                       //
#//  Source:                                                 //
#//  OS: ALL                                                 //
#//  CPU: ALL                                                //
#//                                                          //
#//////////////////////////////////////////////////////////////

DOCKER := docker

PROFILES := wp_db wordpress webserver certbot phpmyadmin flask_website flask_db pgadmin qbittorrent jellyfin
PROFILE_CMD := $(addprefix --profile ,$(PROFILES))


COMPOSE_FILES :=  $(shell find docker-compose* | sed -e 's/^/--file /')

AUTHOR := bensuperpc

.PHONY: build all
all: start

.PHONY: build
build:
	docker compose $(COMPOSE_FILES) $(PROFILE_CMD) build

.PHONY: start
start:
	docker compose $(COMPOSE_FILES) $(PROFILE_CMD) up -d

.PHONY: start-at
start-at:
	docker compose $(COMPOSE_FILES) $(PROFILE_CMD) up

.PHONY: docker-check
docker-check:
	docker compose $(COMPOSE_FILES) $(PROFILES_CMD) config

.PHONY: stop
stop: down

.PHONY: down
down:
	docker compose $(COMPOSE_FILES) $(PROFILE_CMD) down

.PHONY: restart
restart: stop start

.PHONY: logs
logs:
	docker compose $(COMPOSE_FILES) logs

.PHONY: state
state:
	docker compose $(COMPOSE_FILES) ps
	docker compose $(COMPOSE_FILES) top

.PHONY: update
update:
	git pull --recurse-submodules --all --progress
	docker compose $(COMPOSE_FILES) $(PROFILES_CMD) pull

.PHONY: clean
clean:
	$(DOCKER) images --filter=reference='bensuperpc/*' --format='{{.Repository}}:{{.Tag}}' | xargs -r $(DOCKER) rmi -f

.PHONY: purge
purge:
	docker compose $(COMPOSE_FILES) $(PROFILE_CMD) down -v --rmi all