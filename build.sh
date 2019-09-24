docker run \
  -t \
  -p 8005:8005 \
  -v $(pwd)/data:/data \
  bookworm:latest /bin/bash -c " \
    cp /.my.cnf /etc/mysql/my.cnf && \
    cp /.my.cnf /data/bookworm.cnf && \
    find /var/lib/mysql -type f | xargs touch && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    service mysql start && \
    cd /data && \
    bookworm build all && \
    PYTHON_EGG_CACHE='/tmp' bookworm serve
  "
