APP=HelloWorld
BASE_IMAGE=docker.io/adreeve/aspnet:1.0.0-beta6-12100
DOCKER_IMAGE=aspnet-hello
RELEASE_IMAGE=docker.io/adreeve/aspnet-hello

COMMIT := $(shell git show --pretty=format:"%H" --no-patch)

RUN_OPTS=--volume=$(CURDIR)/${APP}:/app \
	--volume=$(CURDIR)/docker/nuget_cache/:/home/aspnet/.local \
	--volume=$(CURDIR)/docker/dnx_packages/:/home/aspnet/.dnx \
	${DOCKER_IMAGE}

run-redis:
	docker run --name hello-redis -d redis

run:
	docker run --link hello-redis:redis -p 5004:5004 ${RUN_OPTS} dnx . kestrel

run-no-redis:
	docker run -p 5004:5004 ${RUN_OPTS} dnx . kestrel

restore:
	docker run ${RUN_OPTS} ./restore.sh

bash:
	docker run -i -t ${RUN_OPTS} /bin/bash

baseimage:
	docker build -t ${BASE_IMAGE} -f ./docker/aspnet.Dockerfile .

build:
	docker build -t ${DOCKER_IMAGE} -f ./docker/dev.Dockerfile .

release_build:
	docker build -t ${RELEASE_IMAGE}:${COMMIT} -f ./docker/release.Dockerfile .

rmi:
	docker rmi -f ${DOCKER_IMAGE}
