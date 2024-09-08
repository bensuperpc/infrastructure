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
ADMIN_SERVICES := yacht uptime-kuma adminer
UTILS_SERVICES := it-tools stirlingpdf
# gitea-runner

PROFILES := caddy homepage $(BLOG_SERVICES) $(SHARING_SERVICES) $(TORRENTS_SERVICES) $(ADMIN_SERVICES) $(UTILS_SERVICES)
PROFILE_CMD := $(addprefix --profile ,$(PROFILES))

COMPOSE_FILES :=  $(shell find . -name 'docker-compose*.yml' -type f | sed -e 's/^/--file /')
COMPOSE_DIR := --project-directory ./infrastructure

UID := 1000
GID := 1000

BUILD_ARG_VAR := --build-arg UID=$(UID) --build-arg GID=$(GID)

.PHONY: build all
all: start

.PHONY: build
build:
	$(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) build

.PHONY: start
start:
	$(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) up -d

.PHONY: start-at
start-at:
	$(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) up

.PHONY: docker-check
docker-check:
	$(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) config

.PHONY: stop
stop: down

.PHONY: down
down:
	$(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) down

.PHONY: restart
restart: stop start

.PHONY: logs
logs:
	$(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) logs

.PHONY: state
state:
	$(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) ps
	$(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) top

.PHONY: update-docker
update-docker:
	$(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) pull

.PHONY: update
update: update-docker
	git submodule update --init --recursive --remote
	git pull --recurse-submodules --all --progress

.PHONY: clean
clean:
	$(DOCKER) images --filter=reference='bensuperpc/*' --format='{{.Repository}}:{{.Tag}}' | xargs -r $(DOCKER) rmi -f

.PHONY: purge
purge:
	$(DOCKER) compose $(COMPOSE_DIR) $(COMPOSE_FILES) $(PROFILE_CMD) down -v --rmi all