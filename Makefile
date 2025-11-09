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

#ADMIN_SERVICES := openssh
# uptime-kuma
#BLOG_SERVICES := wordpress
#IA_SERVICES := open-webui
#SHARING_SERVICES := privatebin
# jellyfin
# psitransfer picoshare projectsend dufs syncthing
#UTILS_SERVICES := it-tools omni-tools cyberchef
# homepage
# stirlingpdf

PROJECT_DIRECTORY := infrastructure
CONFIG_DIRECTORY := presets

CONFIGS := minecraft 7dtd
#DOCKER_PROFILES := 

include DockerCompose.mk
