ARG PHP_VER=7.2
ARG NEXTCLOUD_VER=17.0

FROM nextcloud:${NEXTCLOUD_VER}-fpm AS nextcloud

FROM jeboehm/php-nginx-base:${PHP_VER}
LABEL maintainer="jeff@ressourcenkonflikt.de"

RUN apk add --no-cache \
      bash \
      coreutils \
      findutils \
      rsync && \
    docker-php-ext-install \
      exif \
      pcntl

COPY --from=nextcloud /usr/local/etc/php/conf.d/opcache-recommended.ini /usr/local/etc/php/conf.d/opcache-recommended.ini
COPY --from=nextcloud /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini
COPY --from=nextcloud /usr/local/etc/php/conf.d/memory-limit.ini /usr/local/etc/php/conf.d/memory-limit.ini
COPY --from=nextcloud /entrypoint.sh /entrypoint.sh
COPY --from=nextcloud /upgrade.exclude /upgrade.exclude
COPY --from=nextcloud /usr/src/nextcloud  /usr/src/nextcloud
COPY rootfs/ /

ENV NEXTCLOUD_UPDATE 1

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
