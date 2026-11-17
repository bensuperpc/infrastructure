#//////////////////////////////////////////////////////////////
#//                                                          //
#//  Script, 2022                                            //
#//  Created: 14, April, 2022                                //
#//  Modified: 30, November, 2024                            //
#//  file: -                                                 //
#//  -                                                       //
#//  Source:                                                 //
#//  OS: ALL                                                 //
#//  CPU: ALL                                                //
#//                                                          //
#//////////////////////////////////////////////////////////////

PROJECT_DIRECTORY := infrastructure
CONFIG_DIRECTORY := presets
# Presets in presets/: local_ai tools forgejo dependency-track files office media torrent transmission web monitoring
# Games: 7dtd minecraft satisfactory tf2
CONFIGS := local_ai
#DOCKER_PROFILES := 

include DockerCompose.mk

.PHONY: init
init:
	python3 tools/init_secrets.py

.PHONY: caddy-root
caddy-root:
	$(DOCKER_EXEC) cp caddy:/data/caddy/pki/authorities/local/root.crt caddy-root.crt
