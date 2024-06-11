.PHONY: build build-docker up up-detached down logs exec clean tag push debut-root debut-user

build-docker:
	docker build -t space-station-14-server .

build:
	docker-compose build

up:
	docker-compose up --build

up-detached:
	docker-compose up --build -d

down:
	docker-compose down

logs:
	docker-compose logs -f

exec:
	docker-compose exec ss14-server /bin/bash

clean:
	docker image prune -f

tag:
	docker tag space-station-14-server:latest greenmatthew/ss14-server:latest

push:
	docker push greenmatthew/ss14-server:latest

debug-root:
	docker-compose run --rm --user root --entrypoint /bin/bash ss14-server

debug-user:
	docker-compose run --rm --entrypoint /bin/bash ss14-server
