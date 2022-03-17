
DOCKER?=
APP_NAME?=java-docker
TAG?=11
FROM?=docker.io/openjdk
PORT?=8090
APP_DIR?=app
ATTACH_ENV?=-a=stdin -a=stdout -a=stderr
SECURITY_ENV?=--security-opt label=disable
UNAME := $(shell uname)
VOLUME_ENV=-v "${CURDIR}":/${APP_DIR}
PORT_ENV=-p ${PORT}:8888

ifeq ($(UNAME),Darwin)
  ifeq ($(DOCKER),podman)
    MOUNT =
    APP_DIR =
  endif	 
endif

HAS_DOCKER ?= $(shell command -v docker > /dev/null 2>&1; [ $$? -eq 0 ] && echo 1 || echo 0)
HAS_PODMAN ?= $(shell command -v podman > /dev/null 2>&1; [ $$? -eq 0 ] && echo 1 || echo 0)

ifeq ($(DOCKER), )
  ifeq ($(HAS_DOCKER), 1)
    DOCKER=docker
  endif
  ifeq ($(HAS_PODMAN), 1)
    DOCKER=podman
  endif
endif

DOCKERRUN=${DOCKER} container run \
  --name ${APP_NAME} \
  --rm \
	-t \
  ${PORT_ENV} \
  ${ATTACH_ENV} \
  ${SECURITY_ENV} \
  ${VOLUME_ENV} \
  ${APP_NAME}:${TAG}

DOCKERBUILD=${DOCKER} build \
	--build-arg FROM=${FROM} \
	--build-arg TAG=${TAG}

.PHONY: clean init dev stop console

clean:

init:
	${DOCKERBUILD} -f .config/docker-config/java.dockerfile . -t ${APP_NAME}:${TAG}

dev:
	${DOCKERRUN} -c "cd /app/${APP_DIR} && ./mvnw spring-boot:run"

build:
	${DOCKERRUN} -c "cd /app/${APP_DIR} && ./mvnw clean package"

stop:
	${DOCKER} container stop ${APP_NAME}

console:
	${DOCKER} exec -it ${APP_NAME} /bin/sh
		
clean: docker
	rm -rf ${APP_DIR}/target
ifneq ($(shell ${DOCKER} images -q ${APP_NAME}:${TAG} 2> /dev/null), )
	${DOCKER} rmi ${APP_NAME}:${TAG}
endif

%:
	@:
