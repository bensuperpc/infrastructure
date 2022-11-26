# Infrastructure

_My infrastructure_

## About

This is my infrastructure. It's a collection of scripts and configuration files that I use to manage my servers.
It uses Nginx and docker-compose to run my services (And many other things).
It's a work in progress, and I'm still learning a lot about it.

## Features

- [x] Nginx
- [x] Docker / docker-compose
- [x] Letsencrypt / Certbot
- [x] Flask (Via UWSGI/NGINX)
- [x] Wordpress (Via FASTCGI/NGINX)
- [x] PHPMyAdmin (MariaDB)
- [x] PGAdmin (PostgreSQL)
- [x] Qbittorrent
- [x] Use Flask instead of wordpress as default blog
- [ ] Jellyfin
- [ ] SSL for all subdomains / Services (Not just the main domain)

## Screenshots

## Installation and configuration

### Requirements

- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Web domain](https://www.ovh.com/world/domains/) (I use OVH)
- [Open port 80 and 443 on your router](http://192.168.0.1/) (I use a Orange box with default IP)
- All requirements for my Flask website (See [README.md](bensuperpc_website/README.md))

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

Keep original config file

```sh
cp nginx-conf nginx-conf-original
```

Remove the old config file

```sh
rm -fr nginx-conf
```

Copy _nginx-conf-cert_ to _nginx-conf_, for temporary use to get the SSL certificate

```sh
cp -r nginx-conf-cert nginx-conf
```

Replace certbot commands in _docker-compose.yml_, and replace _bensuperpc.org_ by your domain

```sh
command: certonly --webroot --webroot-path=/var/www/html --email bensuperpc@bensuperpc.fr --agree-tos --rsa-key-size 4096 --no-eff-email --verbose --noninteractive --keep-until-expiring --domain www.bensuperpc.org --domain bensuperpc.org
```

With to get the SSL certificate

```sh
command: certonly --webroot --webroot-path=/var/www/html --email bensuperpc@bensuperpc.fr --agree-tos --rsa-key-size 4096 --no-eff-email --verbose --noninteractive --staging --domain www.bensuperpc.org --domain bensuperpc.org
```

Run the docker-compose and exit with CTRL+C and when you have the SSL certificate

```sh
make start-at
```

Replace certbot commands in _docker-compose.yml_ to update and renew the SSL certificate

```sh
command: certonly --webroot --webroot-path=/var/www/html --email bensuperpc@bensuperpc.fr --agree-tos --rsa-key-size 4096 --no-eff-email --verbose --force-renewal --domain www.bensuperpc.org --domain bensuperpc.org
```

Run the docker-compose to update and renew the SSL certificate and exit with CTRL+C when you have the SSL certificate

```sh
make start-at
```

Now you can replace the certbot commands in _docker-compose.yml_ with the original one

```sh
command: certonly --webroot --webroot-path=/var/www/html --email bensuperpc@bensuperpc.fr --agree-tos --rsa-key-size 4096 --no-eff-email --verbose --noninteractive --keep-until-expiring --domain www.bensuperpc.org --domain bensuperpc.org
```

### Flask website

You can follow the [README.md](bensuperpc_website/README.md) to install the Flask website.

### Wordpress website

For the Wordpress website, you can configure in GUI when you go to the website.

### Start the infrastructure

Start the website with:

```sh
make start-at
```

Stop the website with:

```sh
make stop
```

## URL

You can access to the website with:

- [bensuperpc.org](https://bensuperpc.org) and [www.bensuperpc.org](https://www.bensuperpc.org) (Wordpress for now)
- [flask.bensuperpc.org](http://flask.bensuperpc.org) and [www.flask.bensuperpc.org](http://www.bensuperpc.org) (Flask website, no SSL for now)
- [phpmyadmin.bensuperpc.org](http://phpmyadmin.bensuperpc.org) and [www.phpmyadmin.bensuperpc.org](http://www.phpmyadmin.bensuperpc.org) (PHPMyAdmin for MariaDB)
- [pgadmin.bensuperpc.org](http://pgadmin.bensuperpc.org) and [www.pgadmin.bensuperpc.org](http://www.pgadmin.bensuperpc.org) (PGAdmin for PostgreSQL)
- [qbittorrent.bensuperpc.org](http://qbittorrent.bensuperpc.org) and [www.qbittorrent.bensuperpc.org](http://www.qbittorrent.bensuperpc.org) (Qbittorrent)

## Build with

- [Wordpress](https://wordpress.org/)
- [Gnu Make](https://www.gnu.org/software/make/)
- [Github API](https://docs.github.com/en/rest)
- [Github Actions](https://docs.github.com/en/actions)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/)
- [Digital Ocean](https://www.digitalocean.com/)
- [Digital Ocean - How To Install WordPress with Docker Compose](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-docker-compose)
- [PGAmin](https://www.pgadmin.org/)
- [Qbittorrent](https://www.qbittorrent.org/)
- [Jellyfin](https://jellyfin.org/)
- [Letsencrypt](https://letsencrypt.org/)
- [Certbot](https://certbot.eff.org/)
- [Nginx](https://www.nginx.com/)
- [UWSGI](https://uwsgi-docs.readthedocs.io/en/latest/)

## License

[License](LICENSE)
