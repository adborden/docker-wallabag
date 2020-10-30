FROM alpine:3
ARG wallabag_version=2.3.8

RUN apk upgrade --no-cache && apk add --no-cache \
  composer \
  curl \
  netcat-openbsd \
  php7-amqp \
  php7-bcmath \
  php7-ctype \
  php7-curl \
  php7-dom \
  php7-fpm \
  php7-gd \
  php7-gettext \
  php7-iconv \
  php7-intl \
  php7-json \
  php7-mbstring \
  php7-pdo_pgsql \
  php7-session \
  php7-simplexml \
  php7-sockets \
  php7-tidy \
  php7-tokenizer \
  php7-xml \
  php7-xmlreader

RUN mkdir -p \
  /var/www/wallabag/app/config \
  /var/www/wallabag/data/assets \
  /var/www/wallabag/data/db

RUN curl --silent --location "https://github.com/wallabag/wallabag/archive/${wallabag_version}.tar.gz" | tar xvz --strip-components=1 -C /var/www/wallabag

# Skip the post install composer script (post-cmd) and run it once the
# environment is available. post-cmd does some initialization based on
# parameters.yml, which means we need the environment variables configured and
# the environment is only configured at run time.
RUN cd /var/www/wallabag \
 && SYMFONY_ENV=prod composer install --no-dev -o --prefer-dist --no-progress --no-scripts

COPY parameters.yml /var/www/wallabag/app/config/

COPY php-fpm.conf /etc/php7/php-fpm.d/www.conf
RUN \
  echo "upload_max_filesize = 1024M" >> /etc/php7/php.ini && \
  echo "post_max_size = 1024M" >> /etc/php7/php.ini

COPY entrypoint.sh /usr/local/bin/

RUN \
  addgroup wallabag && \
  adduser --disabled-password -H -G wallabag wallabag && \
  chown -R wallabag:wallabag \
    /var/www/wallabag/data \
    /var/www/wallabag/var \
    /var/www/wallabag/web/uploads


WORKDIR /var/www/wallabag

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["start"]
