# Specify base image
FROM ubuntu:16.04

# install bookworm deps
RUN echo ' * installing bookworm system deps'
RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get dist-upgrade -y && \
  apt-get install -y gcc \
    build-essential \
    python-dev \
    libmysqlclient-dev \
    parallel \
    git \
    vim

# install python deps
RUN echo ' * installing python deps'
RUN apt-get install -y python-dev python-pip

# install python packages
RUN pip install regex==2019.8.19 \
  nltk==3.4.5 \
  numpy==1.16 \
  mysql-python==1.2.5 \
  python-dateutil==2.8.0

# install LAMP stack deps
RUN echo ' * installing LAMP stack deps'

# set the root user password and bypass the password prompt on mysql install
RUN echo mysql-server mysql-server/root_password password womp | debconf-set-selections && \
  echo mysql-server mysql-server/root_password_again password womp | debconf-set-selections

RUN apt-get -y install mysql-server && \
  /etc/init.d/mysql start && \
  export keeper=keeper && \
  export reader=reader && \
  export keeperpass=womp && \
  export readerpass=womp && \
  mysql -u root -p --execute=" \
    CREATE USER IF NOT EXISTS $keeper@'localhost' IDENTIFIED BY '$keeperpass'; \
    GRANT ALL PRIVILEGES ON *.* TO $keeper@'localhost' WITH GRANT OPTION; \
    CREATE USER IF NOT EXISTS $keeper@'%' IDENTIFIED BY '$keeperpass'; \
    GRANT ALL PRIVILEGES ON *.* TO $keeper@'%' WITH GRANT OPTION; \
    \
    CREATE USER IF NOT EXISTS $reader@'localhost' IDENTIFIED BY '$readerpass'; \
    GRANT SELECT ON *.* TO $reader@'localhost' WITH GRANT OPTION; \
    CREATE USER IF NOT EXISTS $reader@'%' IDENTIFIED BY '$readerpass'; \
    GRANT SELECT ON *.* TO $reader@'%' WITH GRANT OPTION; \
    \
    CREATE USER IF NOT EXISTS 'www-data'@'localhost'; \
    GRANT ALL PRIVILEGES ON *.* TO 'www-data'@'localhost'; \
    CREATE USER IF NOT EXISTS 'www-data'@'%'; \
    GRANT ALL PRIVILEGES ON *.* TO 'www-data'@'%'; \
    \
    CREATE USER IF NOT EXISTS 'admin'@'localhost'; \
    GRANT RELOAD,PROCESS ON *.* TO 'admin'@'localhost'; \
    \
    CREATE USER IF NOT EXISTS 'ubuntu'@'localhost'; \
    GRANT SELECT ON *.* TO 'www-data'@'localhost'; \
    CREATE USER IF NOT EXISTS 'ubuntu'@'%'; \
    GRANT SELECT ON *.* TO 'www-data'@'%'; \
    \
    FLUSH PRIVILEGES;"