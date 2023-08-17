#!/usr/bin/env bash

set -euo pipefail

case "${DISABLE:-,,}" in
"true" | "yes" | "y" | "1")
    disable=true
    ;;
*)
    disable=false
    ;;
esac

if [ "$disable" != true ]; then
    exit 0
fi

# https://docs.balena.io/reference/supervisor/supervisor-api/#post-v2applicationsappidstop-service
echo "Stopping service $BALENA_SERVICE_NAME via supervisor API..."
curl --header "Content-Type:application/json" \
    "$BALENA_SUPERVISOR_ADDRESS/v2/applications/$BALENA_APP_ID/stop-service?apikey=$BALENA_SUPERVISOR_API_KEY" \
    -d "{\"serviceName\": \"$BALENA_SERVICE_NAME\"}"

tail -f /dev/null
