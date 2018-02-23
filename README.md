# Tilda test task POC
This project is an implementation of ssl site configurator.

## Deploy with docker
To start it anywhere, you need to build a docker image: `docker build -t sslsite:latest ./`

Then just type `docker-compose up` and open `localhost:8082` in your web browser.

## Deploy with php builtin server

If you have php 7 installed on your machine, you can run a command `php -S 127.0.0.1:8082 -t public` from
the project root and then open `localhost:8082` in your browser. Note, that the application will try to handle
nginx configs at /etc/nginx, so in order to use it, you need nginx installed too.


# Пример решения задачи Tilda
Это простая реализация конфигуратора ssl-сайтов.

## Развёртывание при помощи docker
Для запуска проекта для начала надо собрать образ: `docker build -t sslsite:latest ./`

Затем, запустите команду `docker-compose up` и откройте `localhost:8082` в вашем браузере.

## Запуск через встроенный сервер PHP
Если на компьютере установлены php и nginx, то можно просто запустить команду `php -S 127.0.0.1:8082 -t public`
из папки в проектом. Приложению необходимы права для доступа к конфигам nginx в директории `/etc/nginx`.