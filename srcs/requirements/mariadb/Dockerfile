FROM debian:bullseye

RUN apt update -y
RUN apt upgrade -y
RUN apt-get install mariadb-server -y

COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init_mysql.sh /init_mysql.sh

RUN chmod +x /init_mysql.sh

CMD ["/init_mysql.sh"]