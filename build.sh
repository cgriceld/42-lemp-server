#!/bin/bash

# build image
docker build -t ft_server .
# run container
docker run --name web_serv -it --rm -p 80:80 -p 443:443 ft_server