#!/bin/bash

service mysql start

# create database
echo "CREATE DATABASE wp_cgriceld;" | mysql -u root
# create user and password
echo "CREATE USER 'cgriceld'@'localhost' IDENTIFIED BY 'borntocode';" | mysql -u root
# give rights
echo "GRANT ALL PRIVILEGES ON wp_cgriceld.* TO 'cgriceld'@'localhost' WITH GRANT OPTION;;" | mysql -u root
# reboot privileges
echo "FLUSH PRIVILEGES;" | mysql -u root

# give rights to pma user
echo "GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'school21';" | mysql -u root
# use create_tables.sql to create the configuration storage database and tables
mysql < /var/www/ft_server/phpmyadmin/sql/create_tables.sql
