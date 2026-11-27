# Caddy with the acme-dns DNS provider: wildcard certificate through the DNS-01 challenge
FROM caddy:2.11.9-builder-alpine AS builder

# renovate: datasource=go depName=github.com/caddy-dns/acmedns
ARG CADDY_ACMEDNS_VERSION=v0.7.0

RUN xcaddy build --with github.com/caddy-dns/acmedns@${CADDY_ACMEDNS_VERSION}

FROM caddy:2.11.9-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
