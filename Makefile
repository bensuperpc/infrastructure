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

TORRENTS_SERVICES := qbittorrent transmission
SHARING_SERVICES := psitransfer picoshare privatebin projectsend jellyfin
ADMIN_SERVICES := yacht uptime-kuma adminer
UTILS_SERVICES := it-tools

PROFILES := caddy wordpress syncthing gitea homepage $(SHARING_SERVICES) $(TORRENTS_SERVICES) $(ADMIN_SERVICES) $(UTILS_SERVICES)
PROFILE_CMD := $(addprefix --profile ,$(PROFILES))

# gitea-runner dozzle watchtower

COMPOSE_FILES :=  $(shell find . -name 'docker-compose*.yml' -type f | sed -e 's/^/--file /')

COMPOSE_DIR := --project-directory ./infrastructure

.PHONY: build all
all: start

.PHONY: build
build:
	docker compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) build

.PHONY: start
start:
	docker compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) up -d

.PHONY: start-at
start-at:
	docker compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) up

.PHONY: docker-check
docker-check:
	docker compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) config

.PHONY: stop
stop: down

.PHONY: down
down:
	docker compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) down

.PHONY: restart
restart: stop start

.PHONY: logs
logs:
	docker compose $(COMPOSE_DIR) $(COMPOSE_FILES) logs

.PHONY: state
state:
	docker compose $(COMPOSE_DIR) $(COMPOSE_FILES) ps
	docker compose $(COMPOSE_DIR) $(COMPOSE_FILES) top

.PHONY: update-docker
update-docker:
	docker compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) pull

.PHONY: update
update: update-docker
	git submodule update --init --recursive --remote
	git pull --recurse-submodules --all --progress

.PHONY: clean
clean:
	$(DOCKER) images --filter=reference='bensuperpc/*' --format='{{.Repository}}:{{.Tag}}' | xargs -r $(DOCKER) rmi -f

.PHONY: purge
purge:
	docker compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) down -v --rmi all