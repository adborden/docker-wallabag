IMAGE := adborden/wallabag
REVISION := 1
WALLABAG_VERSION := 2.4.2

VERSION := $(WALLABAG_VERSION)-r$(REVISION)

BUILD_ARGS := --build-arg wallabag_version=$(WALLABAG_VERSION) --tag $(IMAGE)
ifdef PROD
  BUILD_ARGS := --pull --no-cache --tag $(IMAGE):latest --tag $(IMAGE):$(VERSION) $(BUILD_ARGS)
endif


build:
	docker build . $(BUILD_ARGS)

clean:
	docker-compose down -v

lint:
	npx eslint **/*.js

publish:
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

setup:
	npm install

test:
	docker-compose build
	docker-compose up -d
	npm test

up:
	docker-compose up


.PHONY: build clean lint publish test
