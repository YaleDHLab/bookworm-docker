# Usage

```
# build a bookworm image
docker build --tag bookworm --file Dockerfile .

# find the id of the bookworm image you just made
docker images

# start a container (an instance of the bookworm image)
docker run -dit bookworm

# find all bookworm containers (instances of the bookworm image)
docker ps -a

# drop a shell into the container (instance of image)
docker exec -it {{ CONTAINER_ID, e.g. c9989785d56c }} /bin/bash
```