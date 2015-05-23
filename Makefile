APP=HelloWorld
DOCKER_IMAGE=aspnet-hello
RELEASE_IMAGE=docker.io/adreeve/aspnet-hello
DATA_CONTAINER=aspnet-hello-data

COMMIT := $(shell git show --pretty=format:"%H" --no-patch)

RUN_OPTS=--volume=$(CURDIR)/${APP}:/app \
	--volumes-from=${DATA_CONTAINER} \
	${DOCKER_IMAGE}

run:
	docker run -i -p 5004:5004 ${RUN_OPTS} dnx . kestrel

restore:
	docker run ${RUN_OPTS} dnu restore

bash:
	docker run -i -t ${RUN_OPTS} /bin/bash

build:
	docker build -t ${DOCKER_IMAGE} -f ./docker/dev.Dockerfile .
	docker run --name=${DATA_CONTAINER} ${DOCKER_IMAGE} /bin/true

release_build:
	docker build -t ${RELEASE_IMAGE}:${COMMIT} -f ./docker/release.Dockerfile .

rmi:
	docker rmi -f ${DOCKER_IMAGE}
