#!/bin/bash

service mysql start

echo "CREATE DATABASE wp_cgriceld;" | mysql -u root
echo "CREATE USER 'cgriceld'@'localhost' IDENTIFIED BY 'borntocode';" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wp_cgriceld.* TO 'cgriceld'@'localhost' WITH GRANT OPTION;;" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

echo "GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'school21';" | mysql -u root
mysql < /var/www/ft_server/phpmyadmin/sql/create_tables.sql
