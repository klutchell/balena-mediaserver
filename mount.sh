#!/bin/sh

for uuid in $(blkid -sUUID -ovalue /dev/sd??)
do
    mkdir -v /media/"${uuid}" 2>/dev/null
    mount -v UUID="${uuid}" /media/"${uuid}" || exit 1
    chown -v "${PUID}:${PGID}" /media/"${uuid}"
done

exit 0