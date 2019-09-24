FROM ubuntu:16.04
MAINTAINER Douglas Duhaime <douglas.duhaime@gmail.com>

# config
ENV MYSQL_PASSWORD=womp
ENV MYSQL_ROOT=bwroot
ENV MYSQL_USER=bwuser

RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get dist-upgrade -y && \
  # store the mysql root password so the installer doesn't prompt for input
  echo mysql-server mysql-server/root_password password $MYSQL_PASSWORD | debconf-set-selections && \
  echo mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD | debconf-set-selections && \
  apt-get install -y \
    build-essential \
    libmysqlclient-dev \
    mysql-server \
    lamp-server^ \
    python-dev \
    python-pip \
    parallel \
    git \
    curl \
    vim

# enable cgi-bin
RUN a2enmod cgi && \
  service apache2 restart

RUN pip install \
  Flask==1.0.1 \
  matplotlib==2.0.1 \
  mysql-python==1.2.5 \
  nltk==3.4.5 \
  numpy==1.16 \
  pandas==0.19.2 \
  python-dateutil==2.8.0 \
  regex==2019.8.19 \
  scipy==1.0.1

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
    CREATE USER IF NOT EXISTS 'nobody'@'localhost'; \
    GRANT SELECT ON *.* TO 'nobody'@'localhost' WITH GRANT OPTION; \
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

RUN echo " " >> .my.cnf && \
  echo "#" >> .my.cnf && \
  echo "# The MySQL Database Server Configuration File" >> .my.cnf && \
  echo "#" >> .my.cnf && \
  echo " " >> .my.cnf && \
  echo "[client]" >> .my.cnf && \
  echo "user=root" >> .my.cnf && \
  echo "password=$MYSQL_PASSWORD" >> .my.cnf && \
  echo "database=data" >> .my.cnf && \
  echo " " >> .my.cnf && \
  echo "[mysqld]" >> .my.cnf && \
  echo "tmp_table_size=1024M" >> .my.cnf && \
  echo "max_heap_table_size=1024M" >> .my.cnf && \
  echo " " >> .my.cnf

RUN git clone https://github.com/Bookworm-project/BookwormDB
RUN cd BookwormDB && \
  python setup.py install && \
  cp bookwormDB/bin/dbbindings.py /usr/lib/cgi-bin/

EXPOSE 8005