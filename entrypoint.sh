#!/bin/sh

command="${1:-start}"

function wait_for () {
  local host port
  host=$1
  port=$2

  retries=0
  while ! nc -z -w 5 $host $port; do
    if (( $retries > 30 )); then
      # Retry limit exceeded
      return 1
    fi
    retries=$(( $retries + 1 ))
    sleep 1
  done
}

function init () {
    [[ -d /var/www/wallabag/var/cache/prod ]] && return 0

    composer run-script post-cmd
    chown wallabag:wallabag -R /var/www/wallabag/web/uploads /var/www/wallabag/var/cache/prod
    su wallabag -c "bin/console wallabag:install --env=prod --no-interaction"
}

function migrate () {
    su wallabag -c "bin/console doctrine:migrations:migrate --env=prod --no-interaction"
}


case "$command" in
  start)
    # Wait for backing services
    wait_for ${REDIS_HOST:-redis} 6379
    wait_for ${DATABASE_HOST:-db} 5432

    init
    migrate
    exec /usr/sbin/php-fpm7 --fpm-config /etc/php7/php-fpm.conf --nodaemonize --force-stderr
    ;;
  *)
    exec "$@"
    ;;
esac
