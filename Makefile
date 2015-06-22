APP=HelloWorld
BASE_IMAGE=docker.io/adreeve/aspnet:1.0.0-beta6
DOCKER_IMAGE=aspnet-hello
RELEASE_IMAGE=docker.io/adreeve/aspnet-hello
DATA_CONTAINER=aspnet-hello-data

COMMIT := $(shell git show --pretty=format:"%H" --no-patch)

RUN_OPTS=--volume=$(CURDIR)/${APP}:/app \
	--volumes-from=${DATA_CONTAINER} \
	${DOCKER_IMAGE}

run-redis:
	docker run --name hello-redis -d redis

run:
	docker run --link hello-redis:redis -p 5004:5004 ${RUN_OPTS} dnx . kestrel

restore:
	docker run ${RUN_OPTS} ./restore.sh

bash:
	docker run -i -t ${RUN_OPTS} /bin/bash

build:
	docker build -t ${BASE_IMAGE} -f ./docker/aspnet.Dockerfile .
	docker build -t ${DOCKER_IMAGE} -f ./docker/dev.Dockerfile .
	docker run --name=${DATA_CONTAINER} ${DOCKER_IMAGE} /bin/true

release_build:
	docker build -t ${RELEASE_IMAGE}:${COMMIT} -f ./docker/release.Dockerfile .

save_cache:
	# dnu restore is super flakey so allow saving the cache
	# this is an ugly hack
	docker run -v $(CURDIR)/docker/nuget_package_cache:/nuget_package_cache ${RUN_OPTS} \
		/bin/bash -c 'cp -R /home/aspnet/.local/* /nuget_package_cache/'

rmi:
	docker rmi -f ${DOCKER_IMAGE}
