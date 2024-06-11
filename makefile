.PHONY: build
build:
	docker-compose build

.PHONY: up
up:
	docker-compose up --build

.PHONY: up-detached
up-detached:
	docker-compose up --build -d

.PHONY: down
down:
	docker-compose down

.PHONY: logs
logs:
	docker-compose logs -f

.PHONY: exec
exec:
	docker-compose exec ss14-server /bin/bash

.PHONY: clean
clean:
	docker image prune -f

.PHONY: debug-root
debug-root:
	docker-compose run --rm --user root --entrypoint /bin/bash ss14-server

.PHONY: debug-user
debug-user:
	docker-compose run --rm --entrypoint /bin/bash ss14-server
