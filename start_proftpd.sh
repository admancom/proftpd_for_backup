#!/bin/bash
app="proftpd"
docker build -t ${app} .

docker run -d -it -p 0.0.0.0:21:21 -p 0.0.0.0:30091-30100:30091-30100 --restart unless-stopped --name=${app} --mount type=bind,source=/home/ftp2,target=/home/ftp2 ${app}



