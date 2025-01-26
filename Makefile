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

BLOG_SERVICES := wordpress
TORRENTS_SERVICES := qbittorrent transmission
SHARING_SERVICES := psitransfer picoshare privatebin projectsend jellyfin dufs gitea syncthing
ADMIN_SERVICES := yacht uptime-kuma openssh
UTILS_SERVICES := it-tools stirlingpdf
# gitea-runner

PROJECT_DIRECTORY := infrastructure

DOCKER_PROFILES := main_infrastructure caddy homepage $(BLOG_SERVICES) $(SHARING_SERVICES) $(TORRENTS_SERVICES) $(ADMIN_SERVICES) $(UTILS_SERVICES)

include DockerCompose.mk
