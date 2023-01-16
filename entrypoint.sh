#!/bin/sh -e

if [ ! -f /etc/timezone ] && [ ! -z "$TZ" ]; then
  # At first startup, set timezone
  cp /usr/share/zoneinfo/$TZ /etc/localtime
  echo $TZ >/etc/timezone
fi

#if [ -z "$PASV_ADDRESS" ]; then
#  echo "** This container will not run without setting for PASV_ADDRESS **"
#  sleep 10
#  exit 1
#fi

#if [ -e /run/secrets/$FTPUSER_PASSWORD_SECRET ] && ! id -u "$FTPUSER_NAME"; then
#fi

if ! grep -q $FTPUSER_NAME /etc/passwd; then
printf "$FTPUSER_PASSWORD_SECRET\n$FTPUSER_PASSWORD_SECRET\n" | adduser --home /home/data --shell /bin/sh --uid $FTPUSER_UID $FTPUSER_NAME
fi


openssl req -x509 -days 1461 -nodes -newkey rsa:2048 -keyout /etc/ssl/private/proftpd.key -out /etc/ssl/certs/proftpd.crt -subj "/C=RU/ST=SPb/L=SPb/O=Global Security/OU=IT Department/CN=ftp.dmosk.local/CN=ftp"


mkdir -p /run/proftpd && chown proftpd /run/proftpd/

sed -i \
    -e "s:{{ PASV_ADDRESS }}:$PASV_ADDRESS:" \
    -e "s:{{ PASV_MAX_PORT }}:$PASV_MAX_PORT:" \
    -e "s:{{ PASV_MIN_PORT }}:$PASV_MIN_PORT:" \
    -e "s+{{ SERVER_NAME }}+$SERVER_NAME+" \
    /etc/proftpd/proftpd.conf

exec proftpd --nodaemon -c /etc/proftpd/proftpd.conf
