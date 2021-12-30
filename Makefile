
DOCKER?=docker
APP_NAME?=java-docker
TAG?=latest
PORT?=8080
APP_DIR?=app

.PHONY: clean init dev

clean:

init:
	${DOCKER} build \
		-f Dockerfile app/ \
		-t ${APP_NAME}:${TAG} \
		--build-arg TAG=${TAG} 

dev:
	${DOCKER} container run \
		--name ${APP_NAME} \
		--rm \
		-p ${PORT}:${PORT} \
		-v "${CURDIR}":/${APP_DIR} \
		${APP_NAME}:${TAG} \
		-c "cd /app/${APP_DIR} && ./mvnw $(filter-out $@,$(MAKECMDGOALS))"

stop:
	${DOCKER} container stop ${APP_NAME}

console:
	${DOCKER} exec -it ${APP_NAME} /bin/sh
		
%:
	@:
# ref: https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line
