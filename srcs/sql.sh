#!/bin/bash

service mysql start
echo "GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'borntocode';" | mysql -u root
echo "CREATE DATABASE wp_cgriceld;" | mysql -u root
echo "CREATE USER 'root'@'localhost' IDENTIFIED BY 'root';" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wp_cgriceld.* TO 'root'@'localhost' WITH GRANT OPTION;;" | mysql -u root
echo "UPDATE mysql.user SET plugin='mysql_native_password' WHERE user='root';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
