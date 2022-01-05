ARG TAG=11

FROM docker.io/openjdk:${TAG}

WORKDIR /app

COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline

COPY src ./src

ENTRYPOINT ["/bin/bash"]