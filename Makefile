clean:
	docker-compose down -v

lint:
	npx eslint **/*.js

test:
	docker-compose build
	docker-compose up -d
	npm test


.PHONY: clean lint test
