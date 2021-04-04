# LEMP-server

**Simple LEMP (Linux, Nginx, MySQL, PHP) web server using Docker**\
System & network administration 42 project.

To build image and launch server with enabled autoindex run `bash build.sh on`; to run with disabled autoindex (you will get `403 Forbidden` error then) use `bash build.sh off`.

To enable/disable autoindex inside container run `source indexstate.sh on/off` from the root directory.\
To see whether autoindex is currently on or off run `printenv INDEXSTATE`.

To stop container and remove image run `bash stop&del.sh`. Container will be automatically removed as it was launched with `--rm` option in `build.sh`.
