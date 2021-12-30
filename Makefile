
DOCKER?=docker
APP_NAME?=java-docker
TAG?=latest
PORT?=8080
APP_DIR?=app
MOUNT ?= -v "${CURDIR}":/${APP_DIR}
UNAME := $(shell uname)

ifeq ($(UNAME),Darwin)
	ifeq ($(DOCKER),podman)
		MOUNT =
		APP_DIR =
	endif	 
endif

.PHONY: clean init dev stop console

clean:

init:
	${DOCKER} build \
		app/ \
		-t ${APP_NAME}:${TAG} \
		--build-arg TAG=${TAG} 

dev:
	${DOCKER} container run \
		--name ${APP_NAME} \
		--rm \
		-p ${PORT}:${PORT} \
		${MOUNT} \
		${APP_NAME}:${TAG} \
		-c "cd /app/${APP_DIR} && ./mvnw $(filter-out $@,$(MAKECMDGOALS))"

stop:
	${DOCKER} container stop ${APP_NAME}

console:
	${DOCKER} exec -it ${APP_NAME} /bin/sh
		
%:
	@:
# ref: https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line
