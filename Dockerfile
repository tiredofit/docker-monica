FROM docker.io/tiredofit/nginx-php-fpm:8.0
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV MONICA_VERSION=v3.7.0 \
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

RUN set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .monica-build-deps \
                nodejs \
                npm \
                yarn \
                && \
    apk add -t .monica-rundeps \
                expect \
                git \
                sed \
                && \
    mkdir -p /assets/install && \
    php-ext enable core && \
    git clone https://github.com/monicahq/monica /assets/install && \
    cd /assets/install && \
    git checkout -b ${MONICA_VERSION} && \
    composer install --no-interaction --no-suggest --no-dev --ignore-platform-reqs && \
    yarn install && \
    yarn run production && \
    \
    apk del .monica-build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.composer && \
    rm -rf /app/install/*.{xml,yml,properties,neon,md}

ADD install/ /
