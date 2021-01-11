#!/bin/bash

if [ "$1" = "on" ]
then
	if [ "$INDEXSTATE" = "on" ]
	then
		echo "Autoindex is enabled already"
	else
		sed -i 's/autoindex off/autoindex on/' /etc/nginx/sites-available/localhost.conf
		INDEXSTATE="on"
		service nginx restart
		echo "Autoindex is enabled now"
	fi
elif [ "$1" = "off" ]
then
	if [ "$INDEXSTATE" = "off" ]
	then
		echo "Autoindex is disabled already"
	else
		sed -i 's/autoindex on/autoindex off/' /etc/nginx/sites-available/localhost.conf
		INDEXSTATE="off"
		service nginx restart
		echo "Autoindex is disabled now"
	fi
fi