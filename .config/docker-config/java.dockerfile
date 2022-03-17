ARG TAG=11
ARG FROM=docker.io/openjdk

FROM ${FROM}:${TAG}

WORKDIR /app

COPY app/.mvn/ .mvn
COPY app/mvnw app/pom.xml ./
RUN ./mvnw dependency:go-offline

COPY app/src ./src

ENTRYPOINT ["/bin/bash"]