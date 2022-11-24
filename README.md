# wordpress

_My wordpress test_

## About

This is my test wordpress project.
Many configuration files are from [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-docker-compose).

## Features

- [x] Certbot
- [x] Nginx
- [x] Wordpress
- [x] Docker
- [ ] RSS integration

## Screenshots

## Installation

### Requirements

- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Clone and config

Clone this repository to your local machine using:

```sh
git clone --recurse-submodules --remote-submodules https://github.com/bensuperpc/wordpress.git
```

Go to the folder

```sh
cd wordpress
```

### Run with docker

Start the website with:

```sh
make start
```

And go to: [https://127.0.0.1:80/](https://127.0.0.1:80/) or [https://localhost:80/](https://localhost:80/)

Access to the pgadmin with: [https://127.0.0.1:5050/](https://127.0.0.1:5050/) or [https://localhost:5050/](https://localhost:5050/)

Stop the website with:

```sh
make stop
```

Get the logs with:

```sh
make logs
```

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

## License

[License](LICENSE)
