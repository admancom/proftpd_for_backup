FROM alpine:3.17
MAINTAINER Rich Braun "docker@instantlinux.net"
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.license=GPL-2.0 \
    org.label-schema.name=proftpd \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url=https://github.com/instantlinux/docker-tools

ARG PROFTPD_VERSION=1.3.7f-r1
ENV ALLOW_OVERWRITE=on \
    FTPUSER_PASSWORD_SECRET=trollface \
    FTPUSER_NAME=ftpuser \
    FTPUSER_UID=1000 \
    LOCAL_UMASK=022 \
    MAX_INSTANCES=30 \
#    PASV_ADDRESS=185.173.94.135 \
    PASV_MAX_PORT=30100 \
    PASV_MIN_PORT=30091 \
    SERVER_NAME=ProFTPD \
    TIMES_GMT=off \
    TZ=UTC \
    WRITE_ENABLE=AllowAll \
    READ_ENABLE=DenyAll

COPY proftpd.conf.j2 /etc/proftpd/proftpd.conf
RUN chmod 644 /etc/proftpd/proftpd.conf && \
    apk add --update libcrypto1.1 proftpd=$PROFTPD_VERSION tzdata

RUN mkdir /home/data
#VOLUME /etc/proftpd/conf.d /etc/proftpd/modules.d /var/lib/ftp
EXPOSE 21 $PASV_MIN_PORT-$PASV_MAX_PORT

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
