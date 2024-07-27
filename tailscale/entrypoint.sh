#!/usr/bin/env sh

set -eu

case "${DISABLE:-}" in
# match any truthy value
[tT][rR][uU][eE] | [yY] | [yY][eE][sS] | [oO][nN] | 1)
    echo "DISABLE is truthy, exiting..."
    exit 0
    ;;
*) ;;
esac

if [ -z "${TS_AUTH_KEY:-}" ] && [ -z "${TS_AUTHKEY:-}" ]; then
    echo "TS_AUTHKEY is unset, exiting..."
    exit 0
fi

# attempt to load required kernel modules
modprobe tun || true
modprobe wireguard || true

# create tun device if it doesn't exist
mkdir -p /dev/net
[ ! -c /dev/net/tun ] && mknod /dev/net/tun c 10 200

# start tailscaled
/usr/local/bin/containerboot
