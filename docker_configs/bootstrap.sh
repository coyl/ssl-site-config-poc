#!/usr/bin/env bash
pushd /var/www/
rm -rf var/cache/*
composer install --no-scripts -n
popd
php-fpm -D -R;
nginx -g 'daemon off;';
