FROM ubuntu:16.04

# config
ENV MYSQL_PASSWORD=womp
ENV MYSQL_ROOT=keeper
ENV MYSQL_USER=reader

RUN echo ' * installing bookworm system deps'
RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get dist-upgrade -y && \
  echo mysql-server mysql-server/root_password password $MYSQL_PASSWORD | debconf-set-selections && \
  echo mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD | debconf-set-selections && \
  apt-get install -y gcc \
    build-essential \
    python-dev \
    python-pip \
    libmysqlclient-dev \
    parallel \
    git \
    vim \
    mysql-server

RUN echo ' * installing python packages'
RUN pip install regex==2019.8.19 \
  nltk==3.4.5 \
  numpy==1.16 \
  mysql-python==1.2.5 \
  python-dateutil==2.8.0

RUN echo ' * configuring MYSQL'
RUN mkdir -p /var/run/mysqld
RUN mkdir -p /var/lib/mysql
RUN find /var/lib/mysql -type f | xargs touch && \
  chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
  service mysql start && \
  mysql --user root --password=$MYSQL_PASSWORD --execute=" \
    CREATE USER IF NOT EXISTS $MYSQL_ROOT@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD'; \
    GRANT ALL PRIVILEGES ON *.* TO $MYSQL_ROOT@'localhost' WITH GRANT OPTION; \
    CREATE USER IF NOT EXISTS $MYSQL_ROOT@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; \
    GRANT ALL PRIVILEGES ON *.* TO $MYSQL_ROOT@'%' WITH GRANT OPTION; \
    \
    CREATE USER IF NOT EXISTS $MYSQL_USER@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD'; \
    GRANT SELECT ON *.* TO $MYSQL_USER@'localhost' WITH GRANT OPTION; \
    CREATE USER IF NOT EXISTS $MYSQL_USER@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; \
    GRANT SELECT ON *.* TO $MYSQL_USER@'%' WITH GRANT OPTION; \
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