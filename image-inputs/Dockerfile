# use .my.cnf as the system mysql config and the bookworm config
RUN cp .my.cnf /etc/mysql/my.cnf && \
  cp .my.cnf data/bookworm.cnf

RUN find /var/lib/mysql -type f | xargs touch && \
  chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
  service mysql start && \
  cd mysql-data && \
    # bookworm init has already been run
    bookworm build all &&
    bookworm serve