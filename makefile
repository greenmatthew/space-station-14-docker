.PHONY: build
build:
	docker build --build-arg GAME_SERVER_URL=https://cdn.centcomm.spacestation14.com/builds/wizards/builds/1dc1c8f64bf93c278fa437778cd110becdaae601/SS14.Server_linux-x64.zip -t space-station-14 .

.PHONY: tag
tag:
	docker tag space-station-14 space-station-14:latest

.PHONY: run
run:
	docker run -d --name ss14-server space-station-14

.PHONY: stop
stop:
	docker stop ss14-server

.PHONY: restart
restart:
	docker restart ss14-server

.PHONY: rm
rm:
	docker rm ss14-server

.PHONY: logs
logs:
	docker logs ss14-server

.PHONY: shell
exec:
	docker exec -it ss14-server /bin/sh

.PHONY: clean
clean:
	docker image prune -f

.PHONY: debug-root
debug-root:
	docker run -it --user root --entrypoint /bin/bash space-station-14

.PHONY: debug-user
debug-user:
	docker run -it --entrypoint /bin/bash space-station-14
