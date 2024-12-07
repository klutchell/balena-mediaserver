FROM ghcr.io/almeidapaulopt/tsdproxy:1.1.1

# hadolint ignore=DL3018
RUN apk add --no-cache gettext-envsubst

WORKDIR /app
COPY tsdproxy.yaml ./

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["-config", "/config/tsdproxy.yaml"]
