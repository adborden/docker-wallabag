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

### Prerequisites

You'll need to have these tools installed.

- [Docker Compose](https://docs.docker.com/compose/install/)
- [GNU Make](https://www.gnu.org/software/make/)
- [Node.js](https://nodejs.org/en/) 14.x


### Setup

Install test dependencies.

    $  make setup

Build the container.

    $ make build

Bring the containers up.

    $ make up

Open your web browser to [localhost:8080](http://localhost:8080).

Create an admin user.

    $ docker-compose run --rm app bin/console fos:user:create --super-admin

See [Administration](#administration) for more commands.


### Tests

Run the tests.

    $ make test

Keep in mind that the state is stored in the Docker volumes/containers, so if
you've created some state, it _might_ effect the tests. Run the tests with
a clean state.

    $ make clean test


### Publish

Pushes to the `main` branch will trigger the publish task.

Build, tag, and publish the container image to Docker Hub.

    $ make PROD=1 build publish


### Versioning

The container image is versioned based on the wallabag version plus a revision.
You can bump the revision or the wallabag version in the `Makefile`.


## License

[Wallabag](https://github.com/wallabag/wallabag) is licensed under the MIT license.

docker-wallabag is a docker image for the Wallabag read-it-later service.
Copyright (C) 2021  Aaron D Borden

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
