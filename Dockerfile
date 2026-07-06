FROM alpine:3.24.1
LABEL maintainer="green-leader"

#Install Borg & SSH
RUN apk add --no-cache \
    su-exec \
    openssh \
    borgbackup=1.4.4-r1

COPY sshd_config /usr/local/etc/ssh/sshd_config
COPY entry.sh /usr/local/bin/entry.sh

EXPOSE 22
CMD ["sh", "/usr/local/bin/entry.sh"]
