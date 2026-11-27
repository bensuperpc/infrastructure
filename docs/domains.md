# Domains

`<DOMAIN>` is set in `infrastructure/.env`: see [Configuration](configuration.md#domain).

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
