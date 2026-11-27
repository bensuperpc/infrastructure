# Configuration

## infrastructure/.env

Every secret and setting is in one file, `infrastructure/.env` (gitignored), created by `make init` from [.env.example](../infrastructure/.env.example): each `__GENERATE__` becomes a random value. `COMPOSE_PROFILES` there selects the apps to run: see [Apps and profiles](installation.md#apps-and-profiles).

The services' `<name>.env` files, next to their compose file, are tracked in git and hold no secret: they read them as `${NAME}`, e.g. `DATABASE_URL=postgresql://litellm:${LITELLM_DB_PASSWORD}@litellm-postgres:5432/litellm`, so a database and its client share the same value.

Variables exported in your shell (`DOMAIN`, `COMPOSE_PROFILES`...) take precedence over `infrastructure/.env`: unset them before `make`.

## Domain

The domain and the certificates are set once, in `infrastructure/.env`:

| Variable | Online | Local testing (default of `make init`) |
| -------- | ------ | -------------------------------------- |
| `DOMAIN` | `example.com` | `bensuperpc.localhost` |
| `TLS` | `acme-dns`: Let's Encrypt wildcard certificate, see below | `internal`: Caddy's own CA |
| `LISTEN_ADDRESS` | `0.0.0.0` | `127.0.0.1` |

`LISTEN_ADDRESS` applies to every published port: Caddy, acme-dns, SSH (Forgejo, OpenSSH), qBittorrent and the game servers.

The subdomain of each service is in [Domains](domains.md).

## Local testing

`*.localhost` names resolve to 127.0.0.1 without `/etc/hosts`, and Caddy signs the certificates with its own CA, so Authelia works as online. After the first start, import Caddy's root certificate (`caddy-root.crt`, written by this command) in your browser:

```sh
make caddy-root
```

acme-dns starts too, on 127.0.0.1:53, but is not used locally.

## Wildcard certificate (acme-dns)

Online (`TLS=acme-dns`), Caddy gets a single Let's Encrypt certificate for `*.<DOMAIN>` (and one for `<DOMAIN>`) instead of one per subdomain, and renews it automatically. Let's Encrypt checks the TXT record `_acme-challenge.<DOMAIN>`, answered by [acme-dns](https://github.com/acme-dns/acme-dns) on port 53.

1. At the DNS provider of `<DOMAIN>` (OVH...), add once:

```
ns-acme   IN A    <public IP>
acme      IN NS   ns-acme.<DOMAIN>.
```

2. Open port 53, UDP and TCP, to the server.
3. Set `TLS=acme-dns` in `infrastructure/.env`, then register Caddy's account on acme-dns (written to `infrastructure/.env`):

```bash
make acme-dns-register
```

4. Add the record it prints at the DNS provider, once:

```
_acme-challenge   IN CNAME   <ACME_DNS_SUBDOMAIN>.acme.<DOMAIN>.
```

5. `make up`: `docker logs caddy 2>&1 | grep 'certificate obtained'` shows `*.<DOMAIN>` after a few seconds.
