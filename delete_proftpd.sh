#!/bin/bash
app="proftpd"

docker stop $app
docker rm $app
docker rmi $app
