FROM alpine:edge
LABEL maintainer="green-leader"

#Install Borg & SSH
RUN apk add --no-cache \
    su-exec=0.2-r3 \
    openssh=9.8_p1-r1 \
    borgbackup=1.4.0-r0

COPY sshd_config /usr/local/etc/ssh/sshd_config
COPY entry.sh /usr/local/bin/entry.sh

EXPOSE 22
CMD ["sh", "/usr/local/bin/entry.sh"]
