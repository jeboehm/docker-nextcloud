# docker-nextcloud
This uses the official [Nextcloud docker image](https://hub.docker.com/_/nextcloud/) to build a new image
on top of [jeboehm/php-nginx-base](https://hub.docker.com/r/jeboehm/php-nginx-base/).
With this solution you have the benefit of a small, fast and reliable setup using official
Nextcloud components.

To execute the cronjobs automatically, I recommend [jeboehm/cron](https://hub.docker.com/r/jeboehm/cron/)
or simply use your system's cron daemon to start the cron service defined in the
[docker-compose.yml file](https://github.com/jeboehm/docker-nextcloud/blob/master/docker-compose.yml).

You may use [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/) as a frontend proxy.
