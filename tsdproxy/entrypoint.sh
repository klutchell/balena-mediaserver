#!/usr/bin/env sh

envsubst < tsdproxy.yaml > /config/tsdproxy.yaml

exec /tsdproxyd "$@"
