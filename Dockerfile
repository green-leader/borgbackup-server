FROM alpine:3.18
LABEL maintainer="green-leader"

#Install Borg & SSH
RUN apk add --no-cache \
    su-exec=0.2-r3 \
    openssh=9.3_p1-r3 \
    borgbackup=1.2.4-r4

RUN mkdir -p /usr/local/etc/ssh/ && \
    cp /etc/ssh/sshd_config /usr/local/etc/ssh/sshd_config && \
    sed -i \
        -e 's/^#PasswordAuthentication yes$/PasswordAuthentication no/g' \
        -e 's/^PermitRootLogin without-password$/PermitRootLogin no/g' \
        -e 's/^#Port 22$/Port 2222/g' \
        -e 's/^#HostKey \/etc/HostKey \/opt/g' \
        -e 's/^#LogLevel /LogLevel /g' \
        /usr/local/etc/ssh/sshd_config

COPY entry.sh /usr/local/bin/entry.sh

EXPOSE 2222
CMD ["sh", "/usr/local/bin/entry.sh"]
