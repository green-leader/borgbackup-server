#!/usr/bin/env sh

echo "* create borg user"
PUID=${PUID:-1000}
readonly PUID
PGID=${PGID:-1000}
readonly PGID

adduser -Du "${PUID}" borg "${PGID}"
id borg

echo "* Borg version"
borg -V

readonly SSH_KEY_DIR="/opt/ssh"
mkdir -p ${SSH_KEY_DIR} 2>/dev/null
for keytype in ed25519 rsa ; do
	echo "* Checking or creating SSH host key [${keytype}]"
	if [ ! -f "${SSH_KEY_DIR}/ssh_host_${keytype}_key" ] ; then
		keypath="${SSH_KEY_DIR}/ssh_host_${keytype}_key"
		ssh-keygen -q -f "${keypath}" -N '' -t ${keytype}
		chmod go+r "${keypath}"
	fi
done

echo "* Starting SSH server"
su-exec borg /usr/sbin/sshd -D -f /usr/local/etc/ssh/sshd_config
