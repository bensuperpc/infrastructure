#//////////////////////////////////////////////////////////////
#//                                                          //
#//  Infrastructure, 2024                                    //
#//  Created: 14, April, 2022                                //
#//  Modified: 05, May, 2024                                 //
#//  file: -                                                 //
#//  -                                                       //
#//  Source:                                                 //
#//  OS: ALL                                                 //
#//  CPU: ALL                                                //
#//                                                          //
#//////////////////////////////////////////////////////////////

DOCKER := docker

BLOG_SERVICES := wordpress
TORRENTS_SERVICES := qbittorrent transmission
SHARING_SERVICES := psitransfer picoshare privatebin projectsend jellyfin dufs gitea syncthing
ADMIN_SERVICES := yacht uptime-kuma adminer fleet
UTILS_SERVICES := it-tools stirlingpdf
# gitea-runner

PROFILES := caddy homepage $(BLOG_SERVICES) $(SHARING_SERVICES) $(TORRENTS_SERVICES) $(ADMIN_SERVICES) $(UTILS_SERVICES)
PROFILE_CMD := $(addprefix --profile ,$(PROFILES))

COMPOSE_FILES :=  $(shell find . -name 'docker-compose*.yml' -type f | sed -e 's/^/--file /')
COMPOSE_DIR := --project-directory ./infrastructure

UID := 1000
GID := 1000

ENV_ARG_VAR := PUID=$(UID) PGID=$(GID)

.PHONY: build all
all: start

.PHONY: build
build:
	$(ENV_ARG_VAR) $(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) build

.PHONY: start
start:
	$(ENV_ARG_VAR) $(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) up -d

.PHONY: start-at
start-at:
	$(ENV_ARG_VAR) $(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) up

.PHONY: docker-check
docker-check:
	$(ENV_ARG_VAR) $(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) config

.PHONY: stop
stop: down

.PHONY: down
down:
	$(ENV_ARG_VAR) $(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) down

.PHONY: restart
restart: stop start

.PHONY: logs
logs:
	$(ENV_ARG_VAR) $(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) logs

.PHONY: state
state:
	$(ENV_ARG_VAR) $(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) ps
	$(ENV_ARG_VAR) $(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) top

.PHONY: update-docker
update-docker:
	$(ENV_ARG_VAR) $(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) pull

.PHONY: update
update: update-docker
	git submodule update --init --recursive --remote
	git pull --recurse-submodules --all --progress

.PHONY: clean
clean:
	$(ENV_ARG_VAR) $(DOCKER) images --filter=reference='bensuperpc/*' --format='{{.Repository}}:{{.Tag}}' | xargs -r $(DOCKER) rmi -f

.PHONY: purge
purge:
	$(ENV_ARG_VAR) $(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) down -v --rmi all