#!/bin/bash

service nginx restart
service php7.3-fpm start

mysql < /var/www/server/phpmyadmin/sql/create_tables.sql
service mysql restart
bash