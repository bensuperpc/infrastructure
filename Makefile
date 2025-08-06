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

ADMIN_SERVICES := openssh 
#uptime-kuma yacht
#BLOG_SERVICES := wordpress
#7DAYS_TO_DIE_SERVICES := 7daystodie_server 7daystodie_backup
#MINECRAFT_SERVICES := minecraft_server minecraft_backup
#SATISFACTORY_SERVICES := satisfactory_server satisfactory_backup
#GIT_SERVICES := forgejo forgejo-runner
# gitea gitea-runner
#IA_SERVICES := open-webui
#SHARING_SERVICES := psitransfer picoshare privatebin projectsend jellyfin dufs syncthing
#TORRENTS_SERVICES := qbittorrent transmission
#UTILS_SERVICES := it-tools stirlingpdf omni-tools

MAIN_SERVICES := main_infrastructure caddy homepage

PROJECT_DIRECTORY := infrastructure

DOCKER_PROFILES := $(MAIN_SERVICES) \
	$(ADMIN_SERVICES) $(BLOG_SERVICES) $(7DAYS_TO_DIE_SERVICES) $(MINECRAFT_SERVICES) \
	$(SATISFACTORY_SERVICES) \
	$(GIT_SERVICES) $(IA_SERVICES) $(SHARING_SERVICES) \
	$(TORRENTS_SERVICES) $(UTILS_SERVICES)

include DockerCompose.mk
