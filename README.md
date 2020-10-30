# docker-wallabag

Read-it-later service.

**Documentation:** https://doc.wallabag.org/en/


## Configuration

Symfony supports loading from [environment
variables](https://symfony.com/doc/current/configuration.html#configuration-based-on-environment-variables).
Defaults can be set in .env and deployments can override the environment with
a `.env.local`.


## Administration

Many commands are available through `bin/console`. You can get a complete list
with:

    $ docker-compose run bin/console list


### Create an admin user

Username, email, and password will be prompted interactively.

    $ docker-compose run --rm app bin/console fos:user:create --super-admin


### Clear the cache

The cache is part of the container, so most things that would require a cache
clear happen automatically as part of container rebuild or remove/create.

    $ docker-compose exec app bin/console clear:cache


### Import wallabag v2 JSON

An admin user must first enable Redis in the UI. In internal settings, in the
Import section, enable Redis (with the value 1).

    $ docker-compose run --rm app bin/console wallabag:import:redis-worker --env=prod wallabag_v2 -vv


## Development
