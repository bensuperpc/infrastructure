#//////////////////////////////////////////////////////////////
#//                                                          //
#//  docker-multimedia, 2024                                 //
#//  Created: 30, May, 2021                                  //
#//  Modified: 14 November, 2024                             //
#//  file: -                                                 //
#//  -                                                       //
#//  Source:                                                 //
#//  OS: ALL                                                 //
#//  CPU: ALL                                                //
#//                                                          //
#//////////////////////////////////////////////////////////////

PROJECT_DIRECTORY ?= infrastructure

DOCKER_EXEC ?= docker

CONFIG_DIRECTORY ?= configs
CONFIG_FILES ?= $(addprefix $(CONFIG_DIRECTORY)/,$(addsuffix .conf,$(CONFIGS)))
include $(CONFIG_FILES)

DOCKER_PROFILES ?=
EXTRA_PROFILES ?=

PROFILE_CMD ?= $(addprefix --profile ,$(DOCKER_PROFILES) $(EXTRA_PROFILES))

COMPOSE_FILES ?=  $(shell find ./$(PROJECT_DIRECTORY) -maxdepth 1 -name 'docker-compose*.yml' -type f | sed -e 's/^/--file /')
COMPOSE_DIR ?= --project-directory ./$(PROJECT_DIRECTORY)

UID ?= 1000
GID ?= 1000

ENV_ARG_VAR ?= PUID=$(UID) PGID=$(GID)

DOCKER_COMPOSE_COMMAND ?= $(ENV_ARG_VAR) $(DOCKER_EXEC) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD)

.PHONY: build all
all: start

GENERIC_TARGETS := build down up run config logs pull images start restart stop

.PHONY: $(GENERIC_TARGETS)
$(GENERIC_TARGETS):
	$(DOCKER_COMPOSE_COMMAND) $@

.PHONY: start-detached
start-detached:
	$(DOCKER_COMPOSE_COMMAND) up -d

.PHONY: no-start
no-start:
	$(DOCKER_COMPOSE_COMMAND) up --no-start

.PHONY: state
state:
	$(DOCKER_COMPOSE_COMMAND) ps
	$(DOCKER_COMPOSE_COMMAND) top

.PHONY: volumes
volumes:
	$(DOCKER_COMPOSE_COMMAND) config --volumes

.PHONY: git-update
git-update: 
#	git submodule update --init --recursive --remote
	git pull --recurse-submodules --all --progress

.PHONY: update
update: image-update git-update

.PHONY: clean
clean:
	docker system prune -f

.PHONY: purge
purge:
	$(ENV_ARG_VAR) $(DOCKER_EXEC) compose $(COMPOSE_DIR) $(COMPOSE_FILES) down -v --rmi all
