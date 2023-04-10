# Infrastructure

_My personal infrastructure for my servers and services._

**I moved to caddy inetead of nginx, you can find the old version before this commit:**b98fca7af8954770feec0cd962d35f47bde0d5d2**

## About

This is my infrastructure. It's a collection of scripts and configuration files that I use to manage my servers and services.
It uses ~~Nginx ~~ caddy and docker-compose to run my services (And many other things).
It's a **work in progress**, and I'm still learning a lot about it.
If you have any **questions** or **suggestions**, feel free to open an issue or a pull request.

## Features

- [x] caddy 2 reverse proxy
- [x] Docker / docker-compose
- [x] ~~Letsencrypt / Certbot~~ (Caddy)
- [x] Wordpress (Via FASTCGI/caddy)
- [x] PHPMyAdmin (MariaDB)
- [ ] Qbittorrent
- [ ] Jellyfin
- [ ] Gitea
- [ ] Mastodon
- [ ] Minecraft server (Hyperworld v2)
- [ ] SSL for all subdomains / Services (Not just the main domain)

## Screenshots

## Installation and configuration

### Requirements

- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Web domain](https://www.ovh.com/world/domains/) (I use OVH)
- [Open port 80 and 443 on your router](http://192.168.0.1/) (I use a Orange box with default IP)

### Clone

Clone this repository to your local machine using:

```sh
git clone --recurse-submodules --remote-submodules https://github.com/bensuperpc/infrastructure.git
```

Go to the folder

```sh
cd infrastructure
```

### Get the SSL certificate

For all **bensuperpc.org**, you need to replace it with your domain, example: **bensuperpc.com**

```sh
find . \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i 's/bensuperpc.org/bensuperpc.com/g'
```

And then, caddy will generate the certificate for you and renew it automatically :D (It's easier than certbot and nginx)

### Configure the infrastructure

You must create a file named `.env` with the following content:

```sh
MARIADB_ROOT_PASSWORD=<your_root_password>
MARIADB_USER=<your_user>
MARIADB_PASSWORD=<your_password>
```

### Wordpress website

For the Wordpress website, you can configure in GUI when you go to the website.

### Start the infrastructure

Start the website with:

```sh
make start-at
```

Stop the website with (or CTRL+C with the previous command):

```sh
make stop
```

## URL

You can access to the website with:

- [bensuperpc.org](https://bensuperpc.org) and [www.bensuperpc.org](https://www.bensuperpc.org) (Wordpress for now)

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
- [PGAmin](https://www.pgadmin.org/)
- [Qbittorrent](https://www.qbittorrent.org/)
- [Jellyfin](https://jellyfin.org/)
- [Letsencrypt](https://letsencrypt.org/)
- [Certbot](https://certbot.eff.org/)
- [Nginx](https://www.nginx.com/)
- [UWSGI](https://uwsgi-docs.readthedocs.io/en/latest/)

## License

[License](LICENSE)
