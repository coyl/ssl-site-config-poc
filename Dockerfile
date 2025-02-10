FROM php:8.2-fpm

EXPOSE 80

RUN apt-get update && apt-get install -y \
        libmcrypt-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt

RUN apt-get -yqq --force-yes install wget curl zip libpq-dev \
    && docker-php-ext-install -j$(nproc) zip  pdo pdo_pgsql bcmath pcntl sockets

RUN apt-get -yqq --force-yes install nginx nano
RUN rm -f /etc/nginx/sites-enabled/default

RUN apt-get -yqq --force-yes install libxml2-dev && docker-php-ext-install -j$(nproc) soap

COPY docker_configs/php.ini /usr/local/etc/php/
COPY docker_configs/nginx-host.conf /etc/nginx/sites-enabled/site.conf

RUN sed "s/www-data/root/" /usr/local/etc/php-fpm.d/www.conf > /usr/local/etc/php-fpm.d/www.conf.root \
        && rm -f /usr/local/etc/php-fpm.d/www.conf \
        && mv /usr/local/etc/php-fpm.d/www.conf.root /usr/local/etc/php-fpm.d/www.conf

COPY ./ /var/www/
WORKDIR /var/www/

COPY ./docker_configs/composer.phar /usr/local/bin/composer
RUN rm -rf ./var/cache/*

RUN composer install

RUN crontab ./docker_configs/crontab

ENTRYPOINT ["/var/www/docker_configs/bootstrap.sh"]
