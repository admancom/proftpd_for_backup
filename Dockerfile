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
ENV FTPUSER_PASSWORD_SECRET=password \
    FTPUSER_NAME=ftpuser \
    FTPUSER_UID=1230 \
    PASV_MAX_PORT=30100 \
    PASV_MIN_PORT=30091 \
    SERVER_NAME=ProFTPD \
    TZ=UTC

COPY proftpd.conf.j2 /etc/proftpd/proftpd.conf
COPY tls.conf.j2 /etc/proftpd/tls.conf
RUN chmod 644 /etc/proftpd/proftpd.conf && \
    chmod 644 /etc/proftpd/tls.conf && \
    apk add --update proftpd-mod_tls openssl libcrypto1.1 proftpd=$PROFTPD_VERSION tzdata

EXPOSE 21 $PASV_MIN_PORT-$PASV_MAX_PORT

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
