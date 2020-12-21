FROM debian:buster

# running from / by default
RUN apt-get -y update
RUN apt-get -y upgrade
# install stuff
# nginx will automatically start after the installation is complete
RUN apt-get -y install nginx default-mysql-server php7.3 php-fpm php-mysql openssl
# fot phpMyAdmin and wordpress
RUN apt-get -y wget php-mbstring php-zip php-gd php-curl php-gd php-intl php-soap php-xml php-xmlrpc

# SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=ru/ST=Moscow/L=Moscow/O=no/OU=no/CN=localhost/" \
			-keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

# NGINX
# copy server block config file to nginx
RUN cp ./srcs/localhost.conf /etc/nginx/sites-available
# activate it
RUN ln -s /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-enabled/
# create root dir
RUN mkdir -p /var/www/localhost
# change the ownership of the root dir to the nginx user (www-data):
RUN chown -R www-data: /var/www/localhost
# copy home page to root dir
COPY ./srcs/index.html /var/www/localhost

# PHPMYADMIN
# download tarball, latest version, eng language
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-english.tar.gz
# extraxt it
RUN tar -xvf phpMyAdmin-5.0.4-english.tar.gz
# move to folder
RUN mv phpMyAdmin-5.0.4-english/ /var/www/localhost/phpmyadmin
# delete install archive
RUN rm phpMyAdmin-5.0.4-english.tar.gz
# create cache dir and give rights
RUN mkdir -p /var/lib/phpmyadmin/tmp
RUN chown -R www-data: /var/lib/phpmyadmin
# delete draft and copy config file to phpmyadmin dir, give rights
RUN rm /var/www/localhost/phpmyadmin/config.sample.inc.php
COPY ./srcs/config.inc.php /var/www/localhost/phpmyadmin
RUN chown -R www-data: /var/www/localhost/phpmyadmin

# MYSQL
RUN service mysql start
# access mysql shell, -user = root, -password, -e = execute commands and quit
RUN mysql -u root -p -e "CREATE DATABASE cgriceldbase;CREATE USER 'cgriceld'@'localhost' IDENTIFIED BY 'borntocode'; \
							GRANT ALL PRIVILEGES ON cgriceldbase . * TO 'cgriceld'@'localhost';FLUSH PRIVILEGES;"

# CREATE DATABASE cgriceldbase; - create database
# CREATE USER 'cgriceld'@'localhost' IDENTIFIED BY 'borntocode'; - create new user
# GRANT ALL PRIVILEGES ON cgriceldbase . * TO 'cgriceld'@'localhost'; - give access to new database, * . * - all bases, all tables
# FLUSH PRIVILEGES; - restart priviliges

# WORDPRESS
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz
RUN rm latest.tar.gz
RUN rm wordpress/wp-config-sample.php
RUN mv wordpress /var/www/localhost/wordpress
COPY ./srcs/wp-config.php /var/www/localhost/wordpress
RUN chown -R www-data: /var/www/localhost/wordpress

ENV indexstate=on
EXPOSE 80 443

COPY ./srcs/run.sh /

CMD ["bash", "run.sh"]