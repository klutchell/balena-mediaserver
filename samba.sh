#!/bin/bash

cat > /etc/samba/smb.conf << EOF
[global]
    map to guest = Bad User
    workgroup = WORKGROUP
    security = share
    guest account = nobody

EOF

for uuid in $(blkid -sUUID -ovalue /dev/sd??)
do
    mkdir -v /media/"${uuid}" 2>/dev/null
    mount -v UUID="${uuid}" /media/"${uuid}" || continue
    chown -v "${PUID}:${PGID}" /media/"${uuid}"
    cat >> /etc/samba/smb.conf << EOF
[${uuid}]
    path = /media/${uuid}
    guest ok = yes
    writeable = yes
    create mask = 0755

EOF
done

/usr/sbin/smbd --foreground --log-stdout