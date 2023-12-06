#!/usr/bin/env sh

set -eu

case "${DISABLE:-}" in
# match any truthy value
[tT][rR][uU][eE] | [yY] | [yY][eE][sS] | [oO][nN] | [1-9]*)
    echo "service is disabled"
    exit 0
    ;;
*)
    echo "service is enabled"
    ;;
esac

# attempt to load required kernel modules
modprobe tun || true
modprobe wireguard || true

# create tun device if it doesn't exist
mkdir -p /dev/net
[ ! -c /dev/net/tun ] && mknod /dev/net/tun c 10 200

# start tailscaled in the background
/usr/local/bin/containerboot &
pid=$!

# wait for tailscaled to start
sleep 30

# reset existing funnel and serve configurations
tailscale funnel reset || true
tailscale serve reset || true

serve() {
    host=localhost # $1
    port=$2
    funnel=$3
    case "${funnel}" in
    # match any truthy value
    [tT][rR][uU][eE] | [yY] | [yY][eE][sS] | [oO][nN] | [1-9]*)
        tailscale funnel --bg --https="${port}" "http://${host}:${port}"
        ;;
    *)
        tailscale serve --bg --https="${port}" "http://${host}:${port}"
        ;;
    esac
}

serve duplicati 8200 "${FUNNEL_duplicati:-}"
serve jellyfin 8096 "${FUNNEL_jellyfin:-}"
serve netdata 19999 "${FUNNEL_netdata:-}"
serve nzbhydra 5076 "${FUNNEL_nzbhydra:-}"
serve ombi 3579 "${FUNNEL_ombi:-}"
serve overseerr 5055 "${FUNNEL_overseerr:-}"
serve plex 32400 "${FUNNEL_plex:-}"
serve prowlarr 9696 "${FUNNEL_prowlarr:-}"
serve nginx-proxy-manager 81 "${FUNNEL_nginx-proxy-manager:-}"
serve radarr 7878 "${FUNNEL_radarr:-}"
serve sonarr 8989 "${FUNNEL_sonarr:-}"
serve sabnzbd 8080 "${FUNNEL_sabnzbd:-}"
serve tautulli 8181 "${FUNNEL_tautulli:-}"
serve syncthing 8384 "${FUNNEL_syncthing:-}"

wait $pid
