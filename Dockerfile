FROM debian:buster

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install nginx default-mysql-server php7.3 php-fpm php-mysql
RUN apt-get -y install openssl wget

# SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=ru/ST=Moscow/L=Moscow/O=no/OU=no/CN=localhost/" \
			-keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

# NGINX
COPY ./srcs/nginx.conf /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/
RUN rm /etc/nginx/sites-enabled/default

# PHPMYADMIN
WORKDIR /var/www/localhost
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
RUN tar -xzvf phpMyAdmin-5.0.4-all-languages.tar.gz
RUN mv phpMyAdmin-5.0.4-all-languages phpmyadmin
RUN rm phpMyAdmin-5.0.4-all-languages.tar.gz
COPY ./srcs/config.inc.php ./phpmyadmin
WORKDIR /
RUN mkdir -p /var/lib/phpmyadmin/tmp
RUN chown -R www-data: /var/lib/phpmyadmin
RUN chown -R www-data: /var/www/localhost/phpmyadmin

# MYSQL
COPY ./srcs/sql.sh .
RUN bash sql.sh

# WORDPRESS
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN rm latest.tar.gz 
RUN mv wordpress /var/www/localhost/
RUN chown -R www-data: /var/www/localhost/wordpress
COPY ./srcs/wp-config.php /var/www/localhost/wordpress

EXPOSE 80 443

COPY ./srcs/run.sh .

CMD ["bash", "run.sh"]