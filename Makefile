clean:
	docker-compose down -v
test:
	docker-compose build
	docker-compose up -d
	npm test


.PHONY: clean test
