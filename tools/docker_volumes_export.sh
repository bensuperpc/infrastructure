#!/usr/bin/env bash

set -euo pipefail

volumes=(
    7daystodie_backup
    7daystodie_server_save
    7daystodie_server_config_lgsm
    7daystodie_server_log
    7daystodie_server_file
#    satisfactory_server_config
#    satisfactory_backup
    forgejo_data
    wordpress_db
    minecraft_proxy_data
    minecraft_rcon_data
    minecraft_server_data
    minecraft_server_backup
    stirlingpdf_tessdata
    wordpress
#    wordpress_backup
    projectsend_share
    transmission_config
#    public_data
    projectsend_db
    projectsend_config
    open-webui
    jellyfin_cache
    caddy_backup
    caddy_config
    caddy_data
    homepage_log
    syncthing_config
    openssh_config
    qbittorrent_config
    ollama
    stirlingpdf_config
    uptimekuma_data
#    private_data
    transmission_watch
    privatebin_data
    psitransfer_data
#    gitea_db
#    gitea_data
#    gitea_runner
#    gitea_config
    jellyfin_config
    picoshare_data
    forgejo_data
    forgejo_config
    forgejo_db
    forgejo_certs
    forgejo_runner
)

export_volume() {
    local volume="$1"
    echo "Exporting volume: $volume to $(pwd)/$volume.tar.gz"
    docker run --rm -v "$volume:/source" -v "$(pwd):/dest" alpine sh -c 'apk add --no-cache tar && tar --numeric-owner -cpvzf /dest/"$0.tar.gz" -C /source .' "$volume"

}

import_volume() {
    local volume="$1"
    echo "Importing volume: $volume from $(pwd)/$volume.tar.gz"
    docker run --rm -v "$volume:/dest" -v "$(pwd):/source" alpine sh -c 'apk add --no-cache tar && tar --numeric-owner -xpvzf /source/"$0.tar.gz" -C /dest' "$volume"
}

echo "Starting sync process..."

for ((i=0; i < ${#volumes[@]}; i++)); do
    export_volume "${volumes[$i]}"
done

echo "Sync process completed."
