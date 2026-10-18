---
name: Docker
description: Build images and run containers or Compose stacks. Load before any docker or docker compose command.
---

- `docker` and `docker compose` use a separate rootless daemon, host `dind`, not the user's machine. Every command needs user approval: group work into few commands.
- Only `/workspace` is shared with containers, at the same path. Bind mounts must use paths under `/workspace`.
- Do not use `--user`: root in containers is the host user, so created files already belong to them.
- Published ports are reachable at `dind:PORT`, not `localhost`. Example: `curl http://dind:8080`.
- Containers have internet access to pull images. You do not.
- Remove what you started when done: `docker compose down`, `docker rm -f <name>`.
- Docs: ZIM file `/data/devdocs_en_docker.zim`.
