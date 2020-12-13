# hub.docker.com/r/tiredofit/monica

[![Build Status](https://img.shields.io/docker/build/tiredofit/monica.svg)](https://hub.docker.com/r/tiredofit/monica)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/monica.svg)](https://hub.docker.com/r/tiredofit/monica)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/monica.svg)](https://hub.docker.com/r/tiredofit/monica)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/monica.svg)](https://microbadger.com/images/tiredofit/monica)

## Introduction

This will build a container for [Monica](https://monicahq.com/) - A Personal CRM.

- Automatically installs and sets up installation upon first start

- This Container uses a [customized Alpine base](https://hub.docker.com/r/tiredofit/alpine) which includes [s6 overlay](https://github.com/just-containers/s6-overlay) enabled for PID 1 Init capabilities, [zabbix-agent](https://zabbix.org) for individual container monitoring, Cron also installed along with other tools (bash,curl, less, logrotate, nano, vim) for easier management. It also supports sending to external SMTP servers..

[Changelog](CHANGELOG.md)

## Authors

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [Introduction](#introduction)
- [Authors](#authors)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Data-Volumes](#data-volumes)
  - [Environment Variables](#environment-variables)
    - [Core Options](#core-options)
    - [monica Options](#monica-options)
    - [Authentication Settings](#authentication-settings)
    - [Cache and Session Settings](#cache-and-session-settings)
    - [Mail Settings](#mail-settings)
    - [Storage Settings](#storage-settings)
    - [External Login Services](#external-login-services)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [References](#references)

## Prerequisites

This image assumes that you are using a reverse proxy such as
[jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) and optionally the [Let's Encrypt Proxy
Companion @
https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)
in order to serve your pages. However, it will run just fine on it's own if you map appropriate ports. See the examples folder for a docker-compose.yml that does not rely on a reverse proxy.

You will also need an external MariaDB container

## Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/monica) and is the recommended method of installation.

```bash
docker pull tiredofit/monica
```

### Quick Start

- The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

- Set various [environment variables](#environment-variables) to understand the capabilities of this image.
- Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
- Make [networking ports](#networking) available for public access if necessary

**The first boot can take from 2 minutes - 5 minutes depending on your CPU to setup the proper schemas.**

Login to the web server and enter in your admin email address, admin password and start configuring the system!

## Configuration

### Data-Volumes

The following directories are used for configuration and can be mapped for persistent storage.

| Directory        | Description                                                                  |
| ---------------- | ---------------------------------------------------------------------------- |
| `/www/logs`      | Nginx and PHP Log files                                                      |
| `/www/monica` | (Optional) If you want to expose the monica sourcecode expose this volume |
| **OR**           |                                                                              |
| `/data`          | Hold onto your persistent sessions and cache between container restarts      |

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), and [Web Image](https://hub.docker.com/r/tiredofit/nginx), and [PHP Image](https://hub.docker.com/r/tiredofit/nginx-php-fpm) below is the complete list of available options that can be used to customize your installation.

#### Core Options

| Parameter                  | Description                                                      | Default           |
| -------------------------- | ---------------------------------------------------------------- | ----------------- |
| `DB_HOST`                  | Host or container name of MariaDB Server e.g. `monica-db`     |                   |
| `DB_NAME`                  | MariaDB Database name e.g. `monica`                           |                   |
| `DB_PASS`                  | MariaDB Password for above Database e.g. `password`              |                   |
| `DB_PORT`                  | MariaDB Port                                                     | `3306`            |
| `DB_USER`                  | MariaDB Username for above Database e.g. `monica`             |                   |
| `SITE_URL`                 | The full URL that you are serving this application from          | `null`            |
| `TIMEZONE`                 | Timezone - Use Unix Style                                        | `Etc/UTC`         |

#### Monica Options

| Parameter                    | Description                                                                                        | Default    |
| ---------------------------- | -------------------------------------------------------------------------------------------------- | ---------- |

### Networking

The following ports are exposed.

| Port | Description |
| ---- | ----------- |
| `80` | HTTP        |

## Maintenance

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is e.g. monica) bash
```

## References

- <https://www.monicahq.com>
