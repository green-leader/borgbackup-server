FROM alpine:3.18
LABEL maintainer="green-leader"

#Install Borg & SSH
RUN apk add --no-cache \
    su-exec=0.2-r3 \
    openssh=9.3_p1-r3 \
    borgbackup=1.2.4-r4

COPY sshd_config /usr/local/etc/ssh/sshd_config
COPY entry.sh /usr/local/bin/entry.sh

EXPOSE 22
CMD ["sh", "/usr/local/bin/entry.sh"]
