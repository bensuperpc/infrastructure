# Infrastructure

_Open source, decentralized and self-hosted infrastructure for many local services and authentication with Authelia._

## Features

- [x] caddy 2 HTTP/S reverse proxy, Let's Encrypt wildcard certificate with acme-dns
- [x] Authelia (SSO / authentication middleware)
- [x] local_ai: Ollama (Vulkan), Open WebUI, LiteLLM, OpenCode, VS Code server, Kiwix, Docling, Kroki, SearXNG, Speaches (voice), vLLM (optional)
- [x] Compiler Explorer
- [x] qbittorrent and transmission (Torrent client/server)
- [x] Docker / docker-compose
- [x] Homepage (Public and private dashboards, services declared by Docker labels)
- [x] SearXNG (Self-hosted search engine)
- [x] Jellyfin (Eg Netflix, Disney+)
- [x] Immich (Photo and video library, Eg Google Photos)
- [x] Forgejo (Git server, fork of Gitea) and its Actions runner
- [x] Uptime Kuma (Monitoring) and Dozzle (Docker logs)
- [x] Argus (Application update monitoring)
- [x] Renovate (pull requests for new image versions, on GitHub)
- [x] SyncThing (File synchronization)
- [x] Dufs (File server)
- [x] PsiTransfer, ProjectSend, Picoshare (File sharing)
- [x] it-tools, omni-tools and cyberchef (Tools for IT)
- [x] Privatebin
- [x] Memos (Note-taking)
- [x] Stirling PDF and BentoPDF (PDF tools)
- [x] Wordpress (Via FASTCGI/caddy)
- [x] Dependency-Track (SBOM / vulnerability tracking)
- [x] OpenSSH (SFTP / rsync access to the data)
- [x] Restic backups (Caddy, Wordpress, game servers)
- [X] Game (Satisfactory, Minecraft, 7 Days to Die, Team Fortress 2)

## Architecture

A summary, not every service:

```mermaid
flowchart LR
    internet((Internet))

    subgraph core["core"]
        caddy["Caddy<br/>HTTPS, wildcard certificate"]
        acme["acme-dns"]
        authelia["Authelia<br/>login"]
        homepage["Homepage<br/>public and private"]
    end

    pubsites["Public websites<br/>IT tools, PDF tools, Wordpress, public files"]
    privsites["Protected websites<br/>Forgejo, Jellyfin, Immich, file sharing, monitoring..."]

    subgraph ai["local_ai"]
        openwebui["Open WebUI"]
        opencode["OpenCode, VS Code server"]
        litellm["LiteLLM"]
        ollama["Ollama (GPU)"]
        vllm["vLLM (optional)"]
        aitools["SearXNG, Kiwix, Docling, Speaches"]
    end

    games["Game servers<br/>Minecraft, Satisfactory, 7 Days to Die, TF2"]
    ssh["OpenSSH"]

    internet -- "80, 443" --> caddy
    internet -- "53" --> acme
    caddy -- "certificate" --> acme
    caddy -- "login" --> authelia
    caddy --> homepage
    caddy --> pubsites
    caddy -- "after login" --> privsites
    caddy -- "after login" --> openwebui & opencode
    openwebui --> ollama & litellm & aitools
    opencode --> ollama & aitools
    litellm --> vllm
    internet -- "game ports" --> games
    internet -- "2222" --> ssh
```

## Installation and configuration

### Requirements

- [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), GNU Make and Python 3
- [Web domain](https://www.ovh.com/world/domains/) (I use OVH)
- On your router, open the ports of the apps you run, see below

List of ports used by the services in this infrastructure:

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

`make init` creates `infrastructure/.env`, where `COMPOSE_PROFILES` selects the apps to run: see [Apps and profiles](#apps-and-profiles).

`make up` builds the local images (caddy, opencode, vscode-server, compiler-explorer) the first time, and again when their [Dockerfiles](infrastructure/images/) change. They are never pulled: a registry could serve another image under the same name.

Start (in the background), stop, or remove the containers with:

```sh
make up
make stop
make down
```

### Apps and profiles

The infrastructure is one Docker Compose project, [infrastructure/compose.yml](infrastructure/compose.yml), which includes the compose file of each app. Each app has its own profile, named after it, and `COMPOSE_PROFILES` in `infrastructure/.env` selects the apps to run:

```sh
COMPOSE_PROFILES=core,local_ai,openssh
```

| Profile | Services |
| ------- | -------- |
| `core` | Caddy, acme-dns, Authelia, Homepage: needed by the websites, not by the game servers |
| `local_ai` | Ollama, Open WebUI, LiteLLM, OpenCode, VS Code server, Kiwix, Docling, Kroki, SearXNG (for the AI), Speaches: one profile, they depend on each other |
| `vllm` | vLLM, with `local_ai` |
| `openssh` | OpenSSH, port 2222: your data, Caddy's certificates and the game servers |
| `forgejo`, `dependency-track`, `compiler-explorer` | Forgejo and its runner, Dependency-Track, Compiler Explorer |
| `it-tools`, `omni-tools`, `cyberchef`, `bentopdf`, `memos`, `stirlingpdf`, `privatebin` | Tools |
| `dufs`, `picoshare`, `projectsend`, `psitransfer`, `syncthing` | File sharing and synchronization |
| `jellyfin`, `immich`, `qbittorrent`, `transmission` | Media |
| `wordpress`, `searxng` | Websites |
| `uptime-kuma`, `dozzle`, `argus` | Monitoring |
| `7daystodie`, `minecraft`, `satisfactory`, `teamfortress2` | Game servers and their backup (`teamfortress2_backup` for Team Fortress 2) |

`make` runs `docker compose` in `infrastructure/`, which you can also use directly:

```sh
cd infrastructure
docker compose up -d                       # the apps of COMPOSE_PROFILES
docker compose --profile jellyfin up -d    # one more app, the others are not touched
docker compose --profile jellyfin down     # stops only this app
docker compose --profile '*' down          # stops every app, like make down
docker compose --profile local_ai up -d kroki   # one service of an app, for a test
```


The whole project can create over 30 networks, you can increase the number of available networks by configuring Docker's default address pools in `/etc/docker/daemon.json`, then restarting Docker:

```json
{
  "default-address-pools": [
    { "base": "172.30.0.0/16", "size": 24 },
    { "base": "172.31.0.0/16", "size": 24 }
  ]
}
```


### Configure the domain

The domain and the certificates are set once, in [infrastructure/.env](infrastructure/.env.example) (created by `make init`):

```sh
DOMAIN=example.com
TLS=acme-dns
LISTEN_ADDRESS=0.0.0.0
```

Online (`TLS=acme-dns`), Caddy gets a single wildcard certificate for `*.<DOMAIN>` (and one for `<DOMAIN>`) from Let's Encrypt, and renews it automatically: see [Wildcard certificate](#wildcard-certificate-acme-dns). To test locally, see [Local testing](#local-testing).

### Local testing

Set in `infrastructure/.env` (the default of `make init`):

```sh
DOMAIN=bensuperpc.localhost
TLS=internal
LISTEN_ADDRESS=127.0.0.1
```

`*.localhost` names resolve to 127.0.0.1 without `/etc/hosts`, and Caddy signs the certificates with its own CA, so Authelia works as online. After the first start, import Caddy's root certificate (`caddy-root.crt`, written by this command) in your browser:

```sh
make caddy-root
```

acme-dns starts too, on 127.0.0.1:53, but is not used locally.

Variables exported in your shell (`DOMAIN`, `COMPOSE_PROFILES`...) take precedence over `infrastructure/.env`: unset them before `make`.

`LISTEN_ADDRESS` applies to every published port: Caddy, acme-dns, SSH (Forgejo, OpenSSH), qBittorrent and the game servers.

Access: *Public* for everyone, *Authelia* after login for the admins, *Authelia, users* for the users too.

| Domain name | Access | Description |
| ----------- | ------ | ----------- |
| `<DOMAIN>` | Public | Redirect to `www.<DOMAIN>`, like any unknown subdomain |
| `www.<DOMAIN>` | Public | Homepage: public services |
| `public.<DOMAIN>` | Public | Files of the `public_data` volume, read only |
| `authelia.<DOMAIN>` | Public | Authelia login page |
| `homepage.<DOMAIN>` | Authelia | Homepage (private): every service |
| `openwebui.<DOMAIN>` | Authelia, users | Open WebUI: chat and RAG with Ollama (local_ai) |
| `litellm.<DOMAIN>` | Authelia, users | LiteLLM proxy for Open WebUI: external APIs and vLLM (local_ai) |
| `opencode.<DOMAIN>` | Authelia | OpenCode coding agent (local_ai) |
| `vscode.<DOMAIN>` | Authelia | VS Code server, same tools as OpenCode (local_ai) |
| `kiwix.<DOMAIN>` | Authelia, users | Offline documentation (local_ai) |
| `docling.<DOMAIN>` | Authelia | Documents to Markdown (local_ai) |
| `kroki.<DOMAIN>` | Authelia | Diagrams from text (local_ai) |
| `searxng.<DOMAIN>` | Authelia, users | SearXNG self-hosted search engine |
| `git.<DOMAIN>` | Authelia | Forgejo (`forgejo.<DOMAIN>` redirects here) |
| `compiler-explorer.<DOMAIN>` | Authelia | Compiler Explorer |
| `dependency-track.<DOMAIN>` | Authelia | SBOM / vulnerability analysis |
| `jellyfin.<DOMAIN>` | Authelia, users | Jellyfin for media server |
| `immich.<DOMAIN>` | Authelia, users | Immich for photos and videos |
| `torrent.<DOMAIN>` | Authelia, users | qBittorrent (`qbittorrent.<DOMAIN>` redirects here) |
| `transmission.<DOMAIN>` | Authelia | Transmission torrent client |
| `syncthing.<DOMAIN>` | Authelia, users | SyncThing for file synchronization |
| `dufs.<DOMAIN>` | Authelia | Dufs: manage the files of `public_data` |
| `transfer.<DOMAIN>` | Authelia | PsiTransfer for file sharing (`psitransfer.<DOMAIN>` redirects here) |
| `projectsend.<DOMAIN>` | Authelia | ProjectSend for file sharing |
| `picoshare.<DOMAIN>` | Authelia | Picoshare for file sharing |
| `it-tools.<DOMAIN>` | Public | Tools for IT |
| `omni-tools.<DOMAIN>` | Public | Tools for IT |
| `cyberchef.<DOMAIN>` | Public | CyberChef: encoding, decoding, analysis |
| `bentopdf.<DOMAIN>` | Public | BentoPDF: PDF tools in the browser |
| `stirlingpdf.<DOMAIN>` | Authelia | Stirling PDF tools |
| `memos.<DOMAIN>` | Authelia | Memos note-taking app |
| `privatebin.<DOMAIN>` | Authelia | Privatebin |
| `wordpress.<DOMAIN>` | Public | Wordpress website |
| `uptimekuma.<DOMAIN>` | Authelia | Uptime Kuma for monitoring |
| `dozzle.<DOMAIN>` | Authelia | Dozzle for docker logs |
| `argus.<DOMAIN>` | Authelia | Argus for monitoring application updates |


### Configure the infrastructure

Every secret is in one file, `infrastructure/.env` (gitignored), created by `make init` from [.env.example](infrastructure/.env.example): each `__GENERATE__` becomes a random value. 

The services' `<name>.env` files, next to their compose file, are tracked in git and hold no secret: they read them as `${NAME}`, e.g. `DATABASE_URL=postgresql://litellm:${LITELLM_DB_PASSWORD}@litellm-postgres:5432/litellm`, so a database and its client share the same value.

#### Wildcard certificate (acme-dns)

Online, Caddy uses one Let's Encrypt certificate for `*.<DOMAIN>` instead of one per subdomain, let's Encrypt checks the TXT record `_acme-challenge.<DOMAIN>`, answered by [acme-dns](https://github.com/acme-dns/acme-dns) on port 53.

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

#### Authelia - user database

`make init` writes `infrastructure/services/infra/authelia/config/users_database.yml` (gitignored) with one admin, from `AUTHELIA_ADMIN_USER`, `AUTHELIA_ADMIN_EMAIL` and `AUTHELIA_ADMIN_PASSWORD` in `infrastructure/.env`, if the file does not exist yet, to change the password or add users, edit the file with an argon2 hash:

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

The `local_ai` app works offline once downloaded (about 20 GB), Ollama needs a Vulkan GPU (AMD or Intel, `/dev/dri`), the optional vLLM an AMD GPU with ROCm (`/dev/kfd` and `/dev/dri`).

| Service | Role | First access |
| --- | --- | --- |
| Open WebUI | Chat, RAG, voice | The first account created is admin |
| OpenCode | Coding agent with offline docs (Kiwix) | `docker exec opencode opencode pair --url https://opencode.<DOMAIN>` |
| VS Code server | Editor | Password: `VSCODE_SERVER_PASSWORD` |
| LiteLLM | Proxy for external APIs (OpenAI, Anthropic...) | `litellm.<DOMAIN>`, `admin` / `LITELLM_UI_PASSWORD` |
| Ollama | Local models (`OLLAMA_MODEL`, `EMBEDDING_MODEL`) | Pull the models, see below |
| Speaches | Speech to text and text to speech (CPU) | - |
| vLLM | Hugging Face models (`VLLM_MODEL`), optional: profile `vllm` | Add it in LiteLLM, see below |

Open WebUI and OpenCode have no direct internet access: web search goes through SearXNG, limited to the domains in [whitelist.txt](infrastructure/services/ai/searxng/config/whitelist.txt).

Ollama downloads no model by itself, to use it you need to pull the a model from the Ollama library or Hugging Face GGUF:

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

Argus checks about 30 GitHub projects every hour, within GitHub's 60 requests per hour without a token, for more, set `ARGUS_GITHUB_TOKEN` in `infrastructure/.env` with a fine-grained token without any permission.

#### Forgejo - installation

On the first start, `git.<DOMAIN>` shows the installation wizard, filled in from [forgejo.env](infrastructure/services/dev/forgejo/forgejo.env): create the administrator account there. The wizard writes `INSTALL_LOCK = true` to Forgejo's `app.ini`: do not set `FORGEJO__security__INSTALL_LOCK` in `forgejo.env`, Forgejo applies the `FORGEJO__*` variables at every start and `false` would break the installation.

### Forgejo Runner

The `forgejo` app starts a runner, registered without any manual step:

- `forgejo_runner_register` waits for the end of the installation wizard, registers the runner in Forgejo with `FORGEJO_RUNNER_SECRET` (generated by `make init`), then exits.
- `forgejo_runner` then starts with [runner.yml](infrastructure/services/dev/forgejo/config/runner.yml).

Labels for `runs-on:`: `docker` (Node 22), `ubuntu-latest`, `ubuntu-24.04` and `ubuntu-22.04` (`ghcr.io/catthehacker/ubuntu` images). Edit them in `runner.yml`, then `docker restart forgejo_runner`.

`actions/checkout` and the other actions are downloaded from `https://data.forgejo.org`. Jobs reach Forgejo directly at `http://forgejo:3000`, without Authelia.

### Updates (Renovate)

[Renovate](https://docs.renovatebot.com/) runs on GitHub, at night, with the settings of [renovate.json](renovate.json): it opens a pull request for each new version (images, Dockerfiles, GitHub Actions), and a *Dependency Dashboard* issue that lists them all.

Once: install the [Renovate GitHub App](https://github.com/apps/renovate) on the repository. It reads `renovate.json` from the default branch.


### Docker volumes

Each service stores its data in a dedicated Docker volume, which is not shared with other services.

For shared volumes:

| Volume name  | Description |
| ------------ | ----------- |
| public_data  | Public data: everyone can read it at `public.<DOMAIN>` |
| private_data | Private data: OpenSSH, SyncThing, Jellyfin and qBittorrent |


### SSH access

OpenSSH (profile `openssh`) listens on port **2222**, user `admin`, with the key of [OpenSSH - public key](#openssh---public-key), it gives access (SFTP, rsync) to `public_data`, `private_data`, Caddy's certificates (read only) and backups, and the data and backups of the game servers:

```sh
ssh -p 2222 admin@<DOMAIN>
```

### Qbittorrent

To activate the alternative webui theme (VueTorrent), you need to go in the qbittorrent settings, then in the `webui` section, check the `Use alternative webui` and add `/vuetorrent` to text field.



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
- [Homepage Tuto](https://belginux.com/installer-homepage-avec-docker/)
- [ProjectSend](https://www.projectsend.org/)
- [Picoshare](https://github.com/mtlynch/picoshare)
- [Dufs](https://github.com/sigoden/dufs)
- [Memos](https://github.com/usememos/memos)
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
