ARG PHP_VER=7.2
ARG NEXTCLOUD_VER=15.0

FROM nextcloud:${NEXTCLOUD_VER}-fpm AS nextcloud

FROM jeboehm/php-nginx-base:${PHP_VER}
LABEL maintainer="jeff@ressourcenkonflikt.de"

RUN apk add --no-cache \
      bash \
      coreutils \
      findutils \
      rsync && \
    docker-php-ext-install pcntl

COPY --from=nextcloud /usr/local/etc/php/conf.d/opcache-recommended.ini /usr/local/etc/php/conf.d/zzz_nc_opcache.ini
COPY --from=nextcloud /entrypoint.sh /entrypoint.sh
COPY --from=nextcloud /upgrade.exclude /upgrade.exclude
COPY --from=nextcloud /usr/src/nextcloud  /usr/src/nextcloud
COPY nginx.conf /etc/nginx/sites-enabled/10-docker.conf

RUN echo "memory_limit = 512M;" >> /usr/local/etc/php/conf.d/zzz_nextcloud.ini && \
    echo "php_value upload_max_filesize 16G" >> /usr/local/etc/php/conf.d/zzz_nextcloud.ini && \
    echo "php_value post_max_size 16G" >> /usr/local/etc/php/conf.d/zzz_nextcloud.ini

ENV NEXTCLOUD_UPDATE 1

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
