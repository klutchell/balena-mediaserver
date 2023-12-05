#!/usr/bin/env sh

case "${DISABLE}" in
[Tt][Rr][Uu][Ee] | [Yy][Ee][Ss] | [Oo][Nn] | [1])
    echo "Service is disabled"
    exit 0
    ;;
*)
    exec /init "${@}"
    ;;
esac
