FROM debian:buster

# update system and install stuff
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install nginx default-mysql-server php7.3 php-fpm php-mysql php-mbstring
RUN apt-get -y install openssl wget vim
# copy CMD script
COPY ./srcs/run.sh .
COPY ./srcs/indexstate.sh .
# autoindex on by default
ENV INDEXSTATE on

# SSL, generate private key and certificate
RUN openssl req -x509 -nodes -newkey rsa:2048 -days 30 -keyout /etc/ssl/private/nginx-selfsigned.key \
		-out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=ru/ST=Moscow/L=Moscow/O=no/OU=no/CN=localhost/"

# NGINX
# copy config
COPY ./srcs/localhost.conf /etc/nginx/sites-available/
# activate it
RUN ln -s /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-enabled
# remove default config
RUN rm /etc/nginx/sites-enabled/default
# open ports
EXPOSE 80 443

# create root dir and give rights to nginx
RUN mkdir -p /var/www/ft_server/
RUN chown -R www-data:www-data /var/www/ft_server/

# WORDPRESS
# install wordpress, extract it and delete installation archive
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz
RUN rm latest.tar.gz
# move folder and again give rights to nginx
RUN mv wordpress /var/www/ft_server/
RUN chown -R www-data:www-data /var/www/ft_server/wordpress
# copy config
COPY ./srcs/wp-config.php /var/www/ft_server/wordpress

# PHPMYADMIN
# install phpmyadmin (eng), extract it and delete installation file
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-english.tar.gz
RUN tar -xvf phpMyAdmin-5.0.4-english.tar.gz
RUN rm phpMyAdmin-5.0.4-english.tar.gz
# move and rename folder and give rights
RUN mv phpMyAdmin-5.0.4-english/ /var/www/ft_server/phpmyadmin
RUN chown -R www-data:www-data /var/www/ft_server/phpmyadmin
# copy config
COPY ./srcs/config.inc.php /var/www/ft_server/phpmyadmin
# make dir where phpMyAdmin will store its temporary files
RUN mkdir -p /var/lib/phpmyadmin/tmp
RUN chown -R www-data:www-data /var/lib/phpmyadmin

# MYSQL
# copy init script it and launch it
COPY ./srcs/sql_init.sh .
RUN bash sql_init.sh

CMD ["bash", "run.sh"]