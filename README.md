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

# Inside the container

```
# start mysql
/etc/init.d/mysql start

# stop mysql
/etc/init.d/mysql stop

# prepare to set new root password
mysqld_safe --skip-grant-tables &

# get a root shell in the mysql cli
mysql -uroot

# actually reset the root password
use mysql;
update user set authentication_string=PASSWORD("mynewpassword") where User='root';
flush privileges;
quit
```