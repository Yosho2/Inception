FROM debian:bullseye

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get -y install wget
RUN apt-get install -y php7.4
RUN apt-get install -y php-fpm
RUN apt-get install -y php-mysql
RUN apt-get install -y mariadb-client
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www
RUN cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
COPY conf/auto_config.sh /auto_config.sh
RUN chmod +x /auto_config.sh

RUN	chown -R root:root /var/www/wordpress

ENTRYPOINT ["/auto_config.sh"]