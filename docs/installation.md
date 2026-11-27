# Installation

## Requirements

- [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), GNU Make and Python 3
- [Web domain](https://www.ovh.com/world/domains/) (I use OVH)
- On your router, open the ports of the apps you run, see below

## Ports

| Port number | Profile | Service       | Description       |
| ----------- | ------- | ------------- | ----------------- |
| 53 (TCP and UDP) | `core` | acme-dns | DNS for the wildcard certificate |
| 80, 443 (TCP and UDP) | `core` | Caddy | HTTP and HTTPS traffic |
| 22          | `forgejo` | Forgejo   | Git/SSH access    |
| 2222        | `openssh` | OpenSSH   | Global SSH access (SFTP, rsync) |
| 6881 (TCP and UDP) | `qbittorrent` | qBittorrent | Torrent peers |
| 7777 (TCP and UDP), 8888 | `satisfactory` | Satisfactory | Game server ports |
| 25565       | `minecraft` | Minecraft | Game server port  |
| 8100        | `minecraft` | BlueMap   | Minecraft web map |
| 8804        | `minecraft` | Plan      | Minecraft player statistics |
| 26900 to 26902 | `7daystodie` | 7 Days to Die | Game server ports |
| 27015 (TCP and UDP) | `teamfortress2` | Team Fortress 2 | Game server port |

Ollama also listens on 127.0.0.1:11434, for the host only.

Every published port listens on `LISTEN_ADDRESS`: see [Configuration](configuration.md).

## Start and stop

Clone the repository and run `make init` as in the [Quick start](../README.md#quick-start): `make init` creates `infrastructure/.env`, see [Configuration](configuration.md).

Start (in the background), stop, or remove the containers with:

```sh
make up
make stop
make down
```

`make up` builds the local images (caddy, opencode, vscode-server, compiler-explorer, local-ai-init) the first time, and again when their [Dockerfiles](../infrastructure/images/) change. They are never pulled: a registry could serve another image under the same name.

## Apps and profiles

The infrastructure is one Docker Compose project, [infrastructure/compose.yml](../infrastructure/compose.yml), which includes the compose file of each app. Each app has its own profile, named after it, and `COMPOSE_PROFILES` in `infrastructure/.env` selects the apps to run:

```sh
COMPOSE_PROFILES=core,local_ai,openssh
```

| Profile | Services |
| ------- | -------- |
| `core` | Caddy, acme-dns, Authelia, Homepage: needed by the websites, not by the game servers |
| `local_ai` | Ollama, Open WebUI, LiteLLM, OpenCode, VS Code server, Kiwix, Docling, Kroki, SearXNG (for the AI), Speaches: one profile, they depend on each other |
| `vllm` | vLLM, with `local_ai` |
| `openssh` | OpenSSH (SFTP, rsync), see [Services](services.md#openssh) |
| `forgejo`, `dependency-track`, `compiler-explorer` | Forgejo and its runner, Dependency-Track, Compiler Explorer |
| `it-tools`, `omni-tools`, `cyberchef`, `bentopdf`, `memos`, `stirlingpdf`, `privatebin` | Tools |
| `dufs`, `picoshare`, `projectsend`, `psitransfer`, `syncthing` | File sharing and synchronization |
| `jellyfin`, `immich`, `qbittorrent`, `transmission` | Media |
| `wordpress`, `searxng` | Websites |
| `uptime-kuma`, `dozzle`, `argus` | Monitoring |
| `7daystodie`, `minecraft`, `satisfactory`, `teamfortress2` | Game servers and their backup (`teamfortress2_backup` for Team Fortress 2) |

`make` runs `docker compose` in the `infrastructure/` folder of the repository, which you can also use directly:

```sh
cd infrastructure
docker compose up -d                       # the apps of COMPOSE_PROFILES
docker compose --profile jellyfin up -d    # one more app, the others are not touched
docker compose --profile jellyfin down     # stops only this app
docker compose --profile '*' down          # stops every app, like make down
docker compose --profile local_ai up -d kroki   # one service of an app, for a test
```

## Docker networks

The whole project can create over 30 networks, you can increase the number of available networks by configuring Docker's default address pools in `/etc/docker/daemon.json`, then restarting Docker:

```json
{
  "default-address-pools": [
    { "base": "172.30.0.0/16", "size": 24 },
    { "base": "172.31.0.0/16", "size": 24 }
  ]
}
```
