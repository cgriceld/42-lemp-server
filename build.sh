#!/bin/bash

# build image
docker build -t iweb .

# run container depending on parameter
if [ "$1" = "on" ]
then
	echo "Build image with autoindex"
	docker run --name webserv -it --rm -p 80:80 -p 443:443 iweb
elif [ "$1" = "off" ]
then
	echo "Build image without autoindex"
	docker run --name webserv -e INDEXSTATE=off -it --rm -p 80:80 -p 443:443 iweb
fi