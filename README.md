# Developing Java application in local OCI container

All you need for build and run this application to have is [Podman](https://podman.io/) or [Docker](https://www.docker.com/) installed on your computer. All necessary libraries, tools will be installed in your OCI containers on their own way.

## Quick start

1. Clone `git` repository or download the `java-container` repository.

```
git clone git@github.com:reftch/java-container.git
```  

2. Change current directory:

```
cd java-container
````

3. Init project environment and build container image for development.

  ```
  make init
  ```

  This step might take some seconds, because it creates an OCI container image and installs all necessary [Maven](https://maven.apache.org/) dependencies. 

4. Start application in development container (located in the app/ dir):

  ```
  make dev spring-boot:run
  ```

  You can freely change the application's code, it will rebuilt immediately, because container has project's directories like mounted volume. This lets the con­tain­er read & write to the cur­rent direc­to­ry on our com­put­er.

  5. Stop development container:

  ```
  make stop
  ```
