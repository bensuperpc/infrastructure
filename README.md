# Infrastructure

_My personal infrastructure for my servers and services._

## About

This is my infrastructure. It's a collection of scripts and configuration files that I use to manage my servers and services.
It uses caddy and docker-compose to run my services (And many other things).
It's a **work in progress**, and I'm still learning a lot about it.
If you have any **questions** or **suggestions**, feel free to open an issue or a pull request.

## Features

- [x] caddy 2 reverse proxy
- [x] Docker / docker-compose
- [x] Caddy
- [x] Wordpress (Via FASTCGI/caddy)
- [x] Adminer (MariaDB)
- [x] Jellyfin (Media server)
- [x] Gitea (Git server)
- [x] Uptime Kuma (Monitoring)
- [x] qbittorrent server

## Screenshots

## Installation and configuration

### Requirements

- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Web domain](https://www.ovh.com/world/domains/) (I use OVH)
- [Open port 80, 443, 2222 on your router](http://192.168.0.1/)

***To avoid get rate limit from letsencrypt (10 certificates per 3 hours), you need to disable some certificates in the caddyfiles and enable them 3h later...***

### Clone

Clone this repository to your local machine using:

```sh
git clone --recurse-submodules --remote-submodules https://github.com/bensuperpc/infrastructure.git
```

Go to the folder

```sh
cd infrastructure
```

### Configure the domain

For all **bensuperpc.org**, you need to replace it with your domain, example: **mydomain.com**, so the same for **bensuperpc.com** ect...

```sh
find . \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i 's/bensuperpc.org/mydomain.com/g'
```

Check if all bensuperpc.* are replaced by your domain in [Caddyfile](caddy/wordpress/Caddyfile)

And then, caddy will generate the certificate for you and renew it automatically :D

| Domain name | Type | Description |
| --- | --- | --- |
| [bensuperpc.org](https://bensuperpc.org) | Main | Main domain |
| [adminer.bensuperpc.org](https://adminer.bensuperpc.org) | Sub | Adminer for MariaDB for wordpress only |
| [uptimekuma.bensuperpc.org](https://uptimekuma.bensuperpc.org) | Sub | Uptime Kuma for monitoring |
| [qbittorrent.bensuperpc.org](https://qbittorrent.bensuperpc.org) | Sub | Torrent client/server |
| [git.bensuperpc.org](https://git.bensuperpc.org) | Sub | Gitea for git |
| [link.bensuperpc.org](https://link.bensuperpc.org) | Sub | For link shortener |
| [jellyfin.bensuperpc.org](https://jellyfin.bensuperpc.org) | Sub | Jellyfin for media server |
| [syncthing.bensuperpc.org](https://syncthing.bensuperpc.org) | Sub | SyncThing for file synchronization |
| [psitransfer.bensuperpc.org](https://psitransfer.bensuperpc.org) | Sub | PsiTransfer for file sharing |
| bensuperpc.com | Main | Redirect to bensuperpc.org |
| bensuperpc.fr | Main | Redirect to bensuperpc.org |
| bensuperpc.net | Main | Redirect to bensuperpc.org |
| bensuperpc.ovh | Main | Redirect to bensuperpc.org |

### Configure the infrastructure

You need to configure the infrastructure with your own configuration.

You can generate a password with 32 characters:

```sh
openssl rand -base64 32
```

For the [wordpress.env](env/wordpress.env) file, you need to change the password and user for the database.

```sh
WORDPRESS_DB_USER=bensuperpc
WORDPRESS_DB_PASSWORD=lEOEf8cndnDjp84O4Uv5D9zJLJDFatLw
WORDPRESS_DB_NAME=wordpress
WORDPRESS_DB_HOST=wordpress_db:3306
```

For [wordpress_db.env](env/wordpress_db.env) file, you need to change the password(s) and user for the database.
    
```sh
MARIADB_ROOT_PASSWORD=7L1Ncbquax0B2TCOmrjaQl9n5mnY88bQ
MARIADB_USER=bensuperpc
MARIADB_PASSWORD=lEOEf8cndnDjp84O4Uv5D9zJLJDFatLw
MARIADB_DATABASE=wordpress
```

For [adminer.env](env/adminer.env) file, you need to change the password(s) and user for the database.

```sh
MYSQL_ROOT_PASSWORD=7L1Ncbquax0B2TCOmrjaQl9n5mnY88bQ
MYSQL_USER=bensuperpc
MYSQL_PASSWORD=lEOEf8cndnDjp84O4Uv5D9zJLJDFatLw
ADMINER_DEFAULT_SERVER=wordpress_db
```

For [gitea.env](env/gitea.env) file, you need to change the password(s) and user for the database.

```sh
GITEA__database__DB_TYPE=mysql
GITEA__database__HOST=database_gitea:3306
GITEA__database__NAME=gitea
GITEA__database__USER=bensuperpc
GITEA__database__PASSWD=K7s5yoHknnEd7vsZoxb8I3dK9mjToF1j
GITEA__security__SECRET_KEY=ykcZt23an1E4lFHWvrCKdAyt16WAiK9c
```

For [gitea_db.env](env/gitea_db.env) file, you need to change the password(s) and user for the database.

```sh
MYSQL_ROOT_PASSWORD=xpc4zIhHZzWKqVHcjBu4aW6aS7jG8d7X
MYSQL_USER=bensuperpc
MYSQL_PASSWORD=K7s5yoHknnEd7vsZoxb8I3dK9mjToF1j
MYSQL_DATABASE=gitea
```

For [psitransfer.env](env/psitransfer.env) file, you need to change the password(s) and user for the database.

```sh
PSITRANSFER_ADMIN_PASS=n9jLVNT9QUotTJTT91JqH4GyBTg9pvEn
```

### Start the infrastructure

Start the website with:

```sh
make start-at
```

Stop the website with (or CTRL+C with the previous command):

```sh
make stop
```

Remove countainers with:

```sh
make down
```

### All services

You can find all services on the [docker-compose.yml](docker-compose.yml) file or on this table:

| Service | Description | URL |
| --- | --- | --- |
| Wordpress | Wordpress website | [bensuperpc.org](https://bensuperpc.org) and [www.bensuperpc.org](https://www.bensuperpc.org) |
| Adminer | Adminer for MariaDB | [adminer.bensuperpc.org](https://adminer.bensuperpc.org) |
| Uptime Kuma | Uptime Kuma for monitoring | [uptimekuma.bensuperpc.org](https://uptimekuma.bensuperpc.org) |
| qbittorrent | qbittorrent server | [qbittorrent.bensuperpc.org](https://qbittorrent.bensuperpc.org) |
| Gitea | Gitea for git | [git.bensuperpc.org](https://git.bensuperpc.org) |
| Jellyfin | Jellyfin for media server | [jellyfin.bensuperpc.org](https://jellyfin.bensuperpc.org) |
| SyncThing | SyncThing for file synchronization | [syncthing.bensuperpc.org](https://syncthing.bensuperpc.org) |
| PsiTransfer | PsiTransfer for file sharing | [psitransfer.bensuperpc.org](https://psitransfer.bensuperpc.org) |

You can disable some services by removing the service name in PROFILES variable in the [Makefile](Makefile) file.

To enable the gitea CI: https://medium.com/@lokanx/how-to-build-docker-containers-using-gitea-runners-600729555e07

## Build with

- [Wordpress](https://wordpress.org/)
- [Gnu Make](https://www.gnu.org/software/make/)
- [Github API](https://docs.github.com/en/rest)
- [Github Actions](https://docs.github.com/en/actions)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/)
- [How To Start WordPress with Caddy using Docker Compose](https://minhcung.me/how-to-start-wordpress-with-caddy-using-docker-compose-3d31bb9ef88b)
- [Digital Ocean - How To Install WordPress with Docker Compose (nginx)](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-docker-compose)
- [Letsencrypt](https://letsencrypt.org/)
- [Caddy](https://caddyserver.com/)

## License

[License](LICENSE)
