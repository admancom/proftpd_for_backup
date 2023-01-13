#!/bin/bash
app="proftpd"
docker build -t ${app} .

docker run -d -it -p 0.0.0.0:21:21 -p 0.0.0.0:30091-30100:30091-30100 --restart unless-stopped --name=${app} --mount type=bind,source=/home,target=/home/data ${app}



#docker run -d -it -p 127.0.0.1:56733:80 --restart unless-stopped --name=${app} \
#--mount type=bind,source=/var/www/install,target=/app \
#--mount type=bind,source=/srv/tftp,target=/srv/tftp \
#--mount type=bind,source=/etc/dhcp/hosts,target=/srv/hosts \
#${app}
