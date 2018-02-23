FROM php:7.1-fpm

EXPOSE 80

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y --force-yes nodejs build-essential

RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN apt-get -yqq --force-yes install wget curl git zip libpq-dev \
    && docker-php-ext-install -j$(nproc) zip  pdo pdo_pgsql bcmath pcntl sockets

RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini

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

ENTRYPOINT ["/var/www/docker_configs/bootstrap.sh"]
