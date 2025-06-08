# Misc


## Docker Commands

- Builds the docker container image

```shell
docker build -t <IMAGE_NAME>:latest -f Dockerfile .
```

- Runs the docker container as background service

```shell
docker run --name <SERVICE_NAME> -p 8080:8080 -d <IMAGE_NAME>:latest
```

- Shows the docker container's log

```shell
docker logs -f <SERVICE_NAME>
```

- Executes the 'bash' shell in the container

```shell
docker exec -it <SERVICE_NAME> bash
```

```shell
docker run -it <SERVICE_NAME> /bin/bash
```

- Stops and Remove the docker container

```shell
docker stop <SERVICE_NAME> && docker container rm <SERVICE_NAME>
```

docker exec -it <SERVICE_NAME> /bin/bash
docker run <SERVICE_NAME> ls -la



# Reference

https://repost.aws/questions/QUXH3TiPhAQoO-GXAZuIZoVw/docker-compose-flask-container-throws-error-during-start-up-exec-usr-local-bin-gunicorn-exec-format-error

# Quotes


- An apple a day keeps the doctor away
- Action speaks louder than words
