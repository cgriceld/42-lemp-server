#!/bin/bash

# build image
docker build -t iweb .
# run container
docker run --name webserv -it --rm -p 80:80 -p 443:443 iweb