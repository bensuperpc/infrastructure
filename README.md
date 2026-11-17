# Infrastructure

_Open source, decentralized and self-hosted infrastructure for many local services and authentication with Authelia._

## Features

- [x] caddy 2 HTTP/S reverse proxy
- [x] Authelia (SSO / authentication middleware)
- [x] local_ai: Ollama (ROCm), Open WebUI, OpenCode, VS Code server, Kiwix, Docling, Kroki, Speaches (voice)
- [x] Compiler Explorer
- [x] qbittorrent and transmission (Torrent client/server)
- [x] Docker / docker-compose
- [x] Homepage (Dashboard)
- [x] SearXNG (Self-hosted search engine)
- [x] Jellyfin (Eg Netflix, Disney+)
- [x] Immich (Photo and video library, Eg Google Photos)
- [x] Forgejo (Git server, fork of Gitea)
- [x] Uptime Kuma (Monitoring)
- [x] Argus (Application update monitoring)
- [x] SyncThing (File synchronization)
- [x] Dufs (File server)
- [x] PsiTransfer, ProjectSend, Picoshare (File sharing)
- [x] it-tools, omni-tools and cyberchef (Tools for IT)
- [x] Privatebin
- [x] Memos (Note-taking)
- [x] Stirling PDF (PDF tools)
- [x] Wordpress (Via FASTCGI/caddy)
- [x] Dependency-Track (SBOM / vulnerability tracking)
- [X] Game (Satisfactory, Minecraft, 7 Days to Die, Team Fortress 2 etc...)

## Architecture

![Architecture](ressources/arch_infra.png)

## Screenshots

The homepage is a dashboard with many widgets and services.

![Homepage](ressources/homepagev1.jpg)

## Installation and configuration

### Requirements

- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Web domain](https://www.ovh.com/world/domains/) (I use OVH)
- [Open port 80, 443, 22 and 2222 on your router](http://192.168.1.1/)
- For games server, you need to open these ports (7777, 8888, 25565, 26900, 26901, 26903)

List of ports used by the services in this infrastructure:

| Port number | Service       | Description       |
| ----------- | ------------- | ----------------- |
| 80          | Caddy         | HTTP traffic      |
| 443         | Caddy         | HTTPS traffic     |
| 22          | Forgejo       | Git/SSH access    |
| 2222        | OpenSSH       | Global SSH access |
| 7777        | Satisfactory  | Game server port  |
| 8888        | Satisfactory  | Game server port  |
| 25565       | Minecraft     | Game server port  |
| 8100        | Bluemap Minecraft | Web map port  |
| 26900       | 7 Days to Die | Game server port  |
| 26901       | 7 Days to Die | Game server port  |
| 26903       | 7 Days to Die | Game server port  |
| 27015       | Team Fortress 2 | Game server port |


**To avoid get rate limit from letsencrypt (10 certificates per 3 hours), you need to disable some certificates in the caddyfiles and enable them 3h later...**

### Clone

Clone this repository to your local machine using:

```sh
git clone --recurse-submodules --remote-submodules https://github.com/bensuperpc/infrastructure.git
```

Go to the folder

```sh
cd infrastructure
```

### Start the infrastructure

```sh
make init
```

Build the local images (opencode, vscode-server, compiler-explorer), before the first start and after changing [images/dev](infrastructure/images/dev/Dockerfile):

```sh
make build
```

Start the website with:

```sh
make up
```

Stop the website with:

```sh
make stop
```

Remove containers with:

```sh
make down
```

Services are enabled via **preset configuration files** in the [`presets/`](presets/) directory. 

The active presets are declared in the [`Makefile`](Makefile) via the `CONFIGS` variable, for example, `CONFIGS := local_ai` loads `presets/local_ai.conf` which activates the `main_infrastructure`, `caddy`, `homepage` and `local_ai` profiles. It can also be set for one command: `make CONFIGS="local_ai tools" up`.

| Preset             | Services                                                                     |
| ------------------ | ---------------------------------------------------------------------------- |
| `local_ai`         | Ollama, Open WebUI, LiteLLM, OpenCode, VS Code server, Kiwix, Docling, Kroki, SearXNG, Speaches |
| `tools`            | it-tools, omni-tools, CyberChef, BentoPDF, VS Code server, Compiler Explorer |
| `forgejo`          | Forgejo and its runner                                                       |
| `dependency-track` | Dependency-Track                                                             |
| `files`            | Dufs, PicoShare, ProjectSend, PsiTransfer, Syncthing                         |
| `office`           | Memos, Stirling PDF, PrivateBin                                              |
| `media`            | Jellyfin                                                                     |
| `immich`           | Immich (photos and videos)                                                   |
| `torrent`          | qBittorrent, OpenSSH, Uptime Kuma, Dozzle                                    |
| `transmission`     | Transmission (instead of qBittorrent)                                        |
| `web`              | WordPress                                                                    |
| `monitoring`       | Uptime Kuma, Dozzle, Argus                                                   |
| `7dtd`, `minecraft`, `satisfactory`, `tf2` | Game servers                                         |


### Configure the domain

The domain and the certificates are set once, in [infrastructure/.env](infrastructure/.env.example) (created by `make init`):

```sh
DOMAIN=bensuperpc.org
TLS=bensuperpc@gmail.com
LISTEN_ADDRESS=0.0.0.0
```

For local testing:

```sh
DOMAIN=bensuperpc.localhost
TLS=internal
LISTEN_ADDRESS=127.0.0.1
```

`LISTEN_ADDRESS` applies to every published port: Caddy, SSH (Forgejo, OpenSSH), qBittorrent and the game servers.

Online, Caddy gets a Let's Encrypt certificate for each subdomain with the `TLS` e-mail, and renews it automatically. To test locally, see [Local testing](#local-testing).

| Domain name                                                        | Type | Description                                                  |
| ------------------------------------------------------------------ | ---- | ------------------------------------------------------------ |
| [bensuperpc.org](https://bensuperpc.org)                           | Main | Redirect to [www.bensuperpc.org](https://www.bensuperpc.org) |
| [www.bensuperpc.org](https://www.bensuperpc.org)                   | Main | Homepage                                                     |
| [openwebui.bensuperpc.org](https://openwebui.bensuperpc.org)       | Sub  | Open WebUI: chat and RAG with Ollama (local_ai)              |
| [litellm.bensuperpc.org](https://litellm.bensuperpc.org)           | Sub  | LiteLLM proxy for Open WebUI: external APIs (local_ai)       |
| [opencode.bensuperpc.org](https://opencode.bensuperpc.org)         | Sub  | OpenCode coding agent (local_ai)                             |
| [vscode.bensuperpc.org](https://vscode.bensuperpc.org)             | Sub  | VS Code server, same tools as OpenCode                       |
| [kiwix.bensuperpc.org](https://kiwix.bensuperpc.org)               | Sub  | Offline documentation (local_ai)                             |
| [docling.bensuperpc.org](https://docling.bensuperpc.org)           | Sub  | Documents to Markdown (local_ai)                             |
| [kroki.bensuperpc.org](https://kroki.bensuperpc.org)               | Sub  | Diagrams from text (local_ai)                                |
| [compiler-explorer.bensuperpc.org](https://compiler-explorer.bensuperpc.org) | Sub | Compiler Explorer                                  |
| [authelia.bensuperpc.org](https://authelia.bensuperpc.org)         | Sub  | Authelia for authentication                                  |
| [uptimekuma.bensuperpc.org](https://uptimekuma.bensuperpc.org)     | Sub  | Uptime Kuma for monitoring                                   |
| [qbittorrent.bensuperpc.org](https://qbittorrent.bensuperpc.org)   | Sub  | Torrent client/server                                        |
| [dozzle.bensuperpc.org](https://dozzle.bensuperpc.org)             | Sub  | Dozzle for docker logs                                       |
| [transmission.bensuperpc.org](https://transmission.bensuperpc.org) | Sub  | Torrent client/server                                        |
| [forgejo.bensuperpc.org](https://forgejo.bensuperpc.org/)          | Sub  | Fork of Gitea for git                                        |
| [git.bensuperpc.org](https://git.bensuperpc.org)                   | Sub  | Fork of Gitea for git                                        |
| [jellyfin.bensuperpc.org](https://jellyfin.bensuperpc.org)         | Sub  | Jellyfin for media server                                    |
| [immich.bensuperpc.org](https://immich.bensuperpc.org)             | Sub  | Immich for photos and videos                                 |
| [syncthing.bensuperpc.org](https://syncthing.bensuperpc.org)       | Sub  | SyncThing for file synchronization                           |
| [psitransfer.bensuperpc.org](https://psitransfer.bensuperpc.org)   | Sub  | PsiTransfer for file sharing                                 |
| [it-tools.bensuperpc.org](https://it-tools.bensuperpc.org)         | Sub  | Tools for IT                                                 |
| [omni-tools.bensuperpc.org](https://omni-tools.bensuperpc.org)     | Sub  | Tools for IT                                                 |
| [privatebin.bensuperpc.org](https://privatebin.bensuperpc.org)     | Sub  | Privatebin                                                   |
| [projectsend.bensuperpc.org](https://projectsend.bensuperpc.org)   | Sub  | ProjectSend for file sharing                                 |
| [picoshare.bensuperpc.org](https://picoshare.bensuperpc.org)       | Sub  | Picoshare for file sharing                                   |
| [dufs.bensuperpc.org](https://dufs.bensuperpc.org)                 | Sub  | Dufs for file sharing                                        |
| [memos.bensuperpc.org](https://memos.bensuperpc.org)               | Sub  | Memos note-taking app                                        |
| [stirlingpdf.bensuperpc.org](https://stirlingpdf.bensuperpc.org)   | Sub  | Stirling PDF tools                                           |
| [argus.bensuperpc.org](https://argus.bensuperpc.org)               | Sub  | Argus for monitoring application updates                     |
| [searxng.bensuperpc.org](https://searxng.bensuperpc.org)           | Sub  | SearXNG self-hosted search engine                            |
| [dependency-track.bensuperpc.org](https://dependency-track.bensuperpc.org) | Sub | SBOM / vulnerability analysis                       |
| [wordpress.bensuperpc.org](https://wordpress.bensuperpc.org)       | Sub  | Wordpress website                                            |
| [bentopdf.bensuperpc.org](https://bentopdf.bensuperpc.org)         | Sub  | BentoPDF                                                     |


### Configure the infrastructure

Every secret is in one file, `infrastructure/.env` (gitignored), created by `make init` from [.env.example](infrastructure/.env.example): each `__GENERATE__` becomes a random value. 

The services' `<name>.env` files, next to their compose file, are tracked in git and hold no secret: they read them as `${NAME}`, e.g. `DATABASE_URL=postgresql://litellm:${LITELLM_DB_PASSWORD}@litellm-postgres:5432/litellm`, so a database and its client share the same value.

#### Authelia - user database

`make init` writes `infrastructure/services/infra/authelia/config/users_database.yml` (gitignored) with one admin, from `AUTHELIA_ADMIN_USER`, `AUTHELIA_ADMIN_EMAIL` and `AUTHELIA_ADMIN_PASSWORD` in `infrastructure/.env`, if the file does not exist yet. To change the password or add users, edit the file with an argon2 hash:

```sh
docker run --rm authelia/authelia:4.39.28 authelia crypto hash generate argon2 --password 'MyPassword'
```

After 5 wrong passwords in 3 minutes, Authelia refuses logins for 30 minutes.

#### Dozzle - user account

Generate a user entry for [users.yml](infrastructure/services/infra/dozzle/config/users.yml):

```sh
docker run -it --rm amir20/dozzle generate bensuperpc --password mypassword --email bensuperpc@gmail.com --name "bensuperpc"
```

#### OpenSSH - public key

Replace [id_ed25519.pub](infrastructure/services/infra/openssh/config/authorized_keys/id_ed25519.pub) with your own public SSH key.

#### local_ai

The `local_ai` profile runs a local AI stack that works offline once downloaded (about 20 GB), it needs an AMD GPU (ROCm, `/dev/kfd` and `/dev/dri`), an NVIDIA GPU or Intel GPU.

| Service | Role | First access |
| --- | --- | --- |
| Open WebUI | Chat, RAG, voice | The first account created is admin |
| OpenCode | Coding agent with offline docs (Kiwix) | `docker exec opencode opencode pair --url https://opencode.<DOMAIN>` |
| VS Code server | Editor | Password: `VSCODE_SERVER_PASSWORD` |
| LiteLLM | Proxy for external APIs (OpenAI, Anthropic...) | `litellm.<DOMAIN>`, `admin` / `LITELLM_UI_PASSWORD` |
| Ollama | Local models (`OLLAMA_MODEL`, `EMBEDDING_MODEL`) | - |
| Speaches | Speech to text and text to speech (CPU) | - |
| vLLM | Hugging Face models (`VLLM_MODEL`), optional `vllm` profile | Add it in LiteLLM, see below |

Open WebUI and OpenCode have no direct internet access: web search goes through SearXNG, limited to the domains in [whitelist.txt](infrastructure/services/ai/searxng/config/whitelist.txt).

To add models (Ollama library or Hugging Face GGUF):

```bash
docker exec ollama ollama pull qwen3.8:27b
docker exec ollama ollama pull nomic-embed-text-v2-moe # Mandatory embedding model
docker exec ollama ollama pull gemma4:12b
docker exec ollama ollama pull qwen3.5:9b
docker exec ollama ollama pull hf.co/<author>/<repo>:<quant>
```

#### Team Fortress 2 - Steam GSLT

`make init` will remind you: set `TEAMFORTRESS2_SRCDS_TOKEN` in `infrastructure/.env` with your token from [steamcommunity.com/dev/managegameservers](https://steamcommunity.com/dev/managegameservers).

#### Dependency-Track - first login

Default credentials are `admin` / `admin` - **change them on first login**.

#### Argus - GitHub token

Argus checks about 30 GitHub projects every hour, within GitHub's 60 requests per hour without a token. For more, set `ARGUS_GITHUB_TOKEN` in `infrastructure/.env` with a fine-grained token without any permission.

#### Forgejo - installation

On the first start, `git.<DOMAIN>` shows the installation wizard, filled in from [forgejo.env](infrastructure/services/dev/forgejo/forgejo.env): create the administrator account there. The wizard writes `INSTALL_LOCK = true` to Forgejo's `app.ini`: do not set `FORGEJO__security__INSTALL_LOCK` in `forgejo.env`, Forgejo applies the `FORGEJO__*` variables at every start and `false` would break the installation.

### Homepage

You can change the homepage config in these files:

- [bookmarks.yaml](infrastructure/services/infra/homepage/config/bookmarks.yaml)
- [services.yaml](infrastructure/services/infra/homepage/config/services.yaml)
- [settings.yaml](infrastructure/services/infra/homepage/config/settings.yaml)
- [widgets.yaml](infrastructure/services/infra/homepage/config/widgets.yaml)

### Forgejo Runner

The `forgejo` preset starts a runner, registered without any manual step:

- `forgejo_runner_register` waits for the end of the installation wizard, registers the runner in Forgejo with `FORGEJO_RUNNER_SECRET` (generated by `make init`), then exits.
- `forgejo_runner` then starts with [runner.yml](infrastructure/services/dev/forgejo/config/runner.yml).

Labels for `runs-on:`: `docker` (Node 22), `ubuntu-latest`, `ubuntu-24.04` and `ubuntu-22.04` (`ghcr.io/catthehacker/ubuntu` images). Edit them in `runner.yml`, then `docker restart forgejo_runner`.

`actions/checkout` and the other actions are downloaded from `https://data.forgejo.org`. Jobs reach Forgejo directly at `http://forgejo:3000`, without Authelia.

### Docker volumes

This infrastructure uses docker volumes to store data, all configuration/data for each service are not shared between services for security and maintenance reasons, but **public_data** and **private_data** are shared between all services to store your data.

| Volume name  | Description                                                                                                |
| ------------ | ---------------------------------------------------------------------------------------------------------- |
| public_data  | Public data reachable on internet via [dufs.bensuperpc.org](https://dufs.bensuperpc.org), can be disabled. |
| private_data | Private data                                                                                               |

### SSH access

The default port for SSH/rsync is 2222.

You can access to the server with:

```sh
ssh -p 2222 admin@bensuperpc.org
```

### Qbittorrent

To activate the alternative webui theme (VueTorrent), you need to go in the qbittorrent settings, then in the `webui` section, check the `Use alternative webui` and add `/vuetorrent` to text field.


### Local testing

Set in `infrastructure/.env`:

```sh
DOMAIN=bensuperpc.localhost
TLS=internal
LISTEN_ADDRESS=127.0.0.1
```

`*.localhost` names resolve to 127.0.0.1 without `/etc/hosts`, and Caddy signs the certificates with its own CA, so Authelia works as online, after the first start, import Caddy's root certificate in your browser:

```sh
make caddy-root
```

Variables exported in your shell (`DOMAIN`, `OLLAMA_MODEL`...) take precedence over `infrastructure/.env`: unset them before `make`.

## Sources

- [Wordpress](https://wordpress.org/)
- [Gnu Make](https://www.gnu.org/software/make/)
- [Github API](https://docs.github.com/en/rest)
- [Github Actions](https://docs.github.com/en/actions)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/)
- [How To Start WordPress with Caddy using Docker Compose](https://minhcung.me/how-to-start-wordpress-with-caddy-using-docker-compose-3d31bb9ef88b)
- [Digital Ocean - How To Install WordPress with Docker Compose (nginx)](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-docker-compose)
- [Imagisphe](https://imagisphe.re/)
- [Letsencrypt](https://letsencrypt.org/)
- [Caddy](https://caddyserver.com/)
- [Adminer](https://www.adminer.org/)
- [self-hosted-ai-stack](https://triedandtestedbuilds.com/self-hosted-ai-stack-part-1)
- [Uptime Kuma](https://uptime-kuma.com/)
- [qbittorrent](https://www.qbittorrent.org/)
- [Transmission](https://transmissionbt.com/)
- [Gitea](https://gitea.io/)
- [Jellyfin](https://jellyfin.org/)
- [Immich](https://immich.app/)
- [SyncThing](https://syncthing.net/)
- [PsiTransfer](https://psitransfer.com/)
- [It-tools](https://github.com/CorentinTh/it-tools)
- [Omni-tools](https://github.com/iib0011/omni-tools)
- [Privatebin](https://github.com/PrivateBin/PrivateBin)
- [ghost](https://ghost.org)
- [Homepage Tuto](https://belginux.com/installer-homepage-avec-docker/)
- [ProjectSend](https://www.projectsend.org/)
- [Picoshare](https://github.com/mtlynch/picoshare)
- [Dufs](https://github.com/sigoden/dufs)
- [demos](https://github.com/usememos/memos)
- [Stirling PDF](https://github.com/Stirling-Tools/Stirling-PDF)
- [open-webui](https://github.com/open-webui/open-webui)
- [Fix docker volume](https://pratikpc.medium.com/use-docker-compose-named-volumes-as-non-root-within-your-containers-1911eb30f731)
- [Forgejo-runner](https://code.forgejo.org/forgejo/runner)
- [Forgejo-runner](https://huijzer.xyz/posts/55)
- [Forgejo](https://nickcunningh.am/blog/how-to-setup-and-configure-forgejo-with-support-for-forgejo-actions-and-more)
- [Argus](https://github.com/release-argus/Argus)
- [SearXNG](https://github.com/searxng/searxng)
- [Dependency-Track](https://dependencytrack.org/)
- [Authelia](https://www.authelia.com/)
- [BentoPDF](https://github.com/alam00000/bentopdf)

## License

[License](LICENSE)
