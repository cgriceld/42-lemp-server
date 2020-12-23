FROM debian:buster

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install nginx default-mysql-server php7.3 php-fpm php-mysql php-mbstring
RUN apt-get -y install openssl wget
COPY ./srcs/run.sh .

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=ru/ST=Moscow/L=Moscow/O=no/OU=no/CN=localhost/" \
			-keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

COPY ./srcs/localhost.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-enabled
RUN rm /etc/nginx/sites-enabled/default
EXPOSE 80 443

RUN mkdir -p /var/www/ft_server/
RUN chown -R www-data:www-data /var/www/ft_server/
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz
RUN rm latest.tar.gz
RUN mv wordpress /var/www/ft_server/
RUN chown -R www-data:www-data /var/www/ft_server/wordpress
COPY ./srcs/wp-config.php /var/www/ft_server/wordpress

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-english.tar.gz
RUN tar -xvf phpMyAdmin-5.0.4-english.tar.gz
RUN rm phpMyAdmin-5.0.4-english.tar.gz
RUN mv phpMyAdmin-5.0.4-english/ /var/www/ft_server/phpmyadmin
RUN chown -R www-data:www-data /var/www/ft_server/phpmyadmin
COPY ./srcs/config.inc.php /var/www/ft_server/phpmyadmin
RUN mkdir -p /var/lib/phpmyadmin/tmp
RUN chown -R www-data:www-data /var/lib/phpmyadmin

COPY ./srcs/sql_init.sh .
RUN bash sql_init.sh

CMD ["bash", "run.sh"]