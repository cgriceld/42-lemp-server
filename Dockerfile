FROM debian:buster

# running from / by default
RUN sudo apt-get -y update && sudo apt-get -y upgrade
# install stuff
# nginx will automatically start after the installation is complete
RUN sudo apt-get -y install nginx default-mysql-server php7.3 php-fpm php-mysql openssl

# SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=ru/ST=Moscow/L=Moscow/O=no/OU=no/CN=localhost/" \
			-keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

# NGINX
# copy server block config file to nginx
RUN sudo cp ./srcs/localhost.conf /etc/nginx/sites-available
# activate it
RUN sudo ln -s /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-enabled/
# create root dir
RUN sudo mkdir -p /var/www/ft_server
# change the ownership of the root dir to the nginx user (www-data):
RUN sudo chown -R www-data: /var/www/ft_server
# copy home page to root dir
COPY ./srcs/index.html /var/www/ft_server

ENV indexstate=on
EXPOSE 80 443

RUN sudo systemctl restart nginx