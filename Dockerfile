FROM debian:buster
FROM nginx:latest

RUN sudo apt-get update
RUN sudo apt-get install nginx
RUN sudo apt-get install php-fpm mysql-server
