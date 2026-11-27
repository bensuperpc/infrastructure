# Maintenance

## Updates (Renovate)

[Renovate](https://docs.renovatebot.com/) runs on GitHub, at night, with the settings of [renovate.json](../renovate.json): it opens a pull request for each new version (images, Dockerfiles, GitHub Actions), and a *Dependency Dashboard* issue that lists them all.

Once: install the [Renovate GitHub App](https://github.com/apps/renovate) on the repository. It reads `renovate.json` from the default branch.

## Docker volumes

Each service stores its data in a dedicated Docker volume, which is not shared with other services.

For shared volumes:

| Volume name  | Description |
| ------------ | ----------- |
| public_data  | Public data: everyone can read it at `public.<DOMAIN>` |
| private_data | Private data: OpenSSH, SyncThing, Jellyfin and qBittorrent |

[OpenSSH](services.md#openssh) gives SFTP and rsync access to both.
