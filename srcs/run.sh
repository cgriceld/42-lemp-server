#!/bin/bash

# if autoindex off, change it in location / in localhost.conf
if [ "$INDEXSTATE" = "off" ]
then
	sed -i 's/autoindex on/autoindex off/' /etc/nginx/sites-available/localhost.conf
	echo "Autoindex disabled"
fi

# restart or start services
service nginx restart
service php7.3-fpm start
service mysql restart

bash