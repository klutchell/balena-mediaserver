#!/bin/bash

PUID=${PUID:-911}
PGID=${PGID:-911}

groupmod -o -g "${PGID}" abc
usermod -o -u "${PUID}" abc

cat > /etc/samba/smb.conf << EOF
[global]
    null passwords = yes
    map to guest = Bad User
    guest account = abc

EOF

for uuid in $(blkid -sUUID -ovalue /dev/sd??)
do
    mkdir -v /media/"${uuid}" 2>/dev/null
    mount -v UUID="${uuid}" /media/"${uuid}" || continue
    chown -v "${PUID}:${PGID}" /media/"${uuid}"
    cat >> /etc/samba/smb.conf << EOF
[${uuid}]
    path = /media/${uuid}
    read only = no
    guest ok = yes

EOF
done

/usr/sbin/smbd --foreground --log-stdout