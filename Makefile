APP=HelloWorld
DOCKER_IMAGE=aspnet-hello
DATA_CONTAINER=aspnet-hello-data

RUN_OPTS=--volume=$(CURDIR)/${APP}:/app \
	--volumes-from=${DATA_CONTAINER} \
	${DOCKER_IMAGE}

run:
	docker run -i -t -p 5004:5004 ${RUN_OPTS} dnx . kestrel

restore:
	docker run ${RUN_OPTS} dnu restore

bash:
	docker run -i -t ${RUN_OPTS} /bin/bash

build:
	docker build -t ${DOCKER_IMAGE} ./docker
	docker run --name=${DATA_CONTAINER} ${DOCKER_IMAGE} /bin/true

rmi:
	docker rmi -f ${DOCKER_IMAGE}
