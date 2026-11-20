#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

echo "Compose config, every app"
docker compose --file infrastructure/compose.yml --profile '*' config --quiet

docker build --check infrastructure/images/caddy
docker build --check infrastructure/images/dev

echo "Caddyfile, local and online"
docker build -q -t infrastructure/caddy infrastructure/images/caddy > /dev/null
validate() {
    tar -C infrastructure/services/infra/caddy/config -c . \
        | docker run --rm -i "$@" --entrypoint sh infrastructure/caddy \
            -c 'tar -x -C /etc/caddy && caddy validate --config /etc/caddy/Caddyfile'
}
validate -e DOMAIN=example.localhost -e TLS=internal
validate -e DOMAIN=example.com -e TLS=acme-dns \
    -e ACME_DNS_USERNAME=user -e ACME_DNS_PASSWORD=password -e ACME_DNS_SUBDOMAIN=subdomain
