#!/bin/bash

while read -r share
do
    mkdir -v -p /media/"${share}" 2>/dev/null
    mount -v //samba/"${share}" /media/"${share}" -o "guest,uid=${PUID},gid=${PGID}"
done < <(smbclient -g --no-pass -L samba 2>/dev/null | grep '^Disk' | awk -F '|' '{print $2;}')