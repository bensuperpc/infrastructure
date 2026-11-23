#//////////////////////////////////////////////////////////////
#//                                                          //
#//  docker-multimedia, 2024                                 //
#//  Created: 30, May, 2021                                  //
#//  Modified: 23 November, 2026                             //
#//  file: -                                                 //
#//  -                                                       //
#//  Source:                                                 //
#//  OS: ALL                                                 //
#//  CPU: ALL                                                //
#//                                                          //
#//////////////////////////////////////////////////////////////

PROJECT_DIRECTORY ?= infrastructure

DOCKER_EXEC ?= docker

COMPOSE ?= $(DOCKER_EXEC) compose --file $(PROJECT_DIRECTORY)/compose.yml
COMPOSE_ALL ?= $(COMPOSE) --profile '*'

.PHONY: all
all: up

.PHONY: up start-detached
up start-detached:
	$(COMPOSE) up -d

.PHONY: start restart pull build config logs images
start restart pull build config logs images:
	$(COMPOSE) $@

.PHONY: down stop
down stop:
	$(COMPOSE_ALL) $@

.PHONY: no-start
no-start:
	$(COMPOSE) up --no-start

.PHONY: state
state:
	$(COMPOSE) ps
	$(COMPOSE) top

.PHONY: volumes
volumes:
	$(COMPOSE) config --volumes


.PHONY: git-update
git-update:
#	git submodule update --init --recursive --remote
	git pull --recurse-submodules --all --progress

.PHONY: update
update: git-update

.PHONY: clean
clean:
	$(DOCKER_EXEC) system prune -f

.PHONY: purge
purge:
	$(COMPOSE_ALL) down -v --rmi all
