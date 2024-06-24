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

PROFILES := caddy wordpress adminer backup transmission syncthing uptime-kuma jellyfin qbittorrent psitransfer
PROFILE_CMD := $(addprefix --profile ,$(PROFILES))

# gitea-runner watchtower gitea

COMPOSE_FILES :=  $(shell find docker-compose*.yml | sed -e 's/^/--file /')

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
	docker compose $(COMPOSE_FILES) $(PROFILE_CMD) config

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

.PHONY: update-docker
update-docker:
	docker compose $(COMPOSE_FILES) $(PROFILE_CMD) pull

.PHONY: update
update: update-docker
#	git submodule update --init --recursive --remote
#	git pull --recurse-submodules --all --progress

.PHONY: clean
clean:
	$(DOCKER) images --filter=reference='bensuperpc/*' --format='{{.Repository}}:{{.Tag}}' | xargs -r $(DOCKER) rmi -f

.PHONY: purge
purge:
	docker compose $(COMPOSE_FILES) $(PROFILE_CMD) down -v --rmi all