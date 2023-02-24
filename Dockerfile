ARG DISTRO=alpine
ARG PHP_VERSION=8.1

FROM docker.io/tiredofit/nginx-php-fpm:${PHP_VERSION}-${DISTRO}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG MONICA_VERSION

ENV MONICA_VERSION=${MONICA_VERSION:-"v4.0.0"} \
    MONICA_REPO_URL=https://github.com/monicahq/monica \
    NGINX_WEBROOT=/www/monica \
    NGINX_SITE_ENABLED=monica \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_BCMATH=TRUE \
    PHP_ENABLE_CURL=TRUE \
    PHP_ENABLE_DOM=TRUE \
    PHP_ENABLE_FILEINFO=TRUE \
    PHP_ENABLE_GD=TRUE \
    PHP_ENABLE_GMP=TRUE \
    PHP_ENABLE_ICONV=TRUE \
    PHP_ENABLE_IGBINARY=TRUE \
    PHP_ENABLE_INTL=TRUE \
    PHP_ENABLE_JSON=TRUE \
    PHP_ENABLE_MBSTRING=TRUE \
    PHP_ENABLE_MYSQLI=TRUE \
    PHP_ENABLE_OPENSSL=TRUE \
    PHP_ENABLE_PDO_MYSQL=TRUE \
    PHP_ENABLE_REDIS=TRUE \
    PHP_ENABLE_SESSION=TRUE \
    PHP_ENABLE_SODIUM=TRUE \
    PHP_ENABLE_TOKENIZER=TRUE \
    PHP_ENABLE_XML=TRUE \
    PHP_ENABLE_ZIP=TRUE \
    PHP_ENABLE_IMAGICK=TRUE \
    STAGE=PRODUCTION \
    IMAGE_NAME="tiredofit/monica" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-monica/"

RUN source /assets/functions/00-container && \
    set -x && \
    package update && \
    package upgrade && \
    package install .monica-build-deps \
                nodejs \
                npm \
                yarn \
                && \
    package install .monica-rundeps \
                expect \
                git \
                sed \
                && \
    \
    php-ext enable core && \
    clone_git_repo "${MONICA_REPO_URL}" "${MONICA_VERSION}" /assets/install && \
    composer install --no-interaction --no-suggest --no-dev --ignore-platform-reqs && \
    yarn install && \
    yarn run production && \
    \
    package remove .monica-build-deps && \
    package cleanup && \
    rm -rf \
            /assets/install/*.md \
            /assets/install/*.neon \
            /assets/install/*.properties \
            /assets/install/*.xml \
            /assets/install/*.yml \
            /assets/install/Procfile \
            /assets/install/node_modules \
            /root/.composer \
            /root/.cache \
            /usr/local/share/.cache

COPY install/ /

