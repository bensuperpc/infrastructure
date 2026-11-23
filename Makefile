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

include DockerCompose.mk

.PHONY: init
init:
	python3 tools/init_secrets.py

.PHONY: check
check:
	tools/check.sh

# Online (TLS=acme-dns): start acme-dns, register Caddy's account (once) and print the CNAME to create
.PHONY: acme-dns-register
acme-dns-register:
	$(COMPOSE) up -d --wait acme-dns
	python3 tools/acme_dns_register.py

.PHONY: caddy-root
caddy-root:
	$(DOCKER_EXEC) cp caddy:/data/caddy/pki/authorities/local/root.crt caddy-root.crt
