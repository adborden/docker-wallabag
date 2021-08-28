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

    $ make build test

Keep in mind that the state is stored in the Docker volumes/containers, so if
you've created some state, it _might_ effect the tests. Run the tests with
a clean state.

    $ make clean test


### Scanning

CI runs weekly and on each push. The weekly scan fetches the `latest` tag in
order to detect any new vulnerabilities since the image was published. The push
workflow scans the image built from the branch in order to test vulnerabilities
introduced from any changes _before_ the changes are accepted.


### Publish

Pushes to the `main` branch will trigger the publish task.

Build, tag, and publish the container image to Docker Hub.

    $ make PROD=1 build publish


### Versioning

The container image is versioned based on the wallabag version plus a revision.
You can bump the revision or the wallabag version in the `Makefile`.
