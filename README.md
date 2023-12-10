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
- [x] Caddy
- [x] Wordpress (Via FASTCGI/caddy)
- [x] Adminer (MariaDB)
- [x] Portainer ce

## Screenshots

## Installation and configuration

### Requirements

- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Web domain](https://www.ovh.com/world/domains/) (I use OVH)
- [Open port 80 and 443 on your router](http://192.168.0.1/) (I use a SFR box with default IP)

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

For all **bensuperpc.org**, you need to replace it with your domain, example: **mydomain.com**

```sh
find . \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i 's/bensuperpc.org/mydomain.com/g'
```

Check if all bensuperpc.* are replaced by your domain in [Caddyfile](caddy/wordpress/Caddyfile)

And then, caddy will generate the certificate for you and renew it automatically :D (It's easier than certbot and nginx)

| Domain name | Description |
| --- | --- |
| bensuperpc.org | Main domain |
| bensuperpc.com | Redirect to bensuperpc.org |
| bensuperpc.fr | Redirect to bensuperpc.org |
| bensuperpc.net | Redirect to bensuperpc.org |
| bensuperpc.ovh | Redirect to bensuperpc.org |

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
WORDPRESS_DB_HOST=database:3306
```

For [mariadb.env](env/mariadb.env) file, you need to change the password(s) and user for the database.
    
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
ADMINER_DEFAULT_SERVER=database
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
| Portainer ce | Portainer ce | [portainer.bensuperpc.org](https://portainer.bensuperpc.org) |

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
- [Letsencrypt](https://letsencrypt.org/)
- [Caddy](https://caddyserver.com/)

## License

[License](LICENSE)
