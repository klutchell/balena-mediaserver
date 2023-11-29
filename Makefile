
include .env
export

LOCAL_SSH_PORT ?= 22222
LOCAL_HTTP_PORT ?= 8080

.PHONY: tunnel
tunnel:
	@$(MAKE) stop
ifeq ($(UUID),)
	@echo "UUID is not set. Please set it in .env or pass it as an argument."
	@exit 1
endif
ifeq ($(USERNAME),)
	@echo "USERNAME is not set. Please set it in .env or pass it as an argument."
	@exit 1
endif
ifeq ($(PORT),)
	@echo "PORT is not set. Please set it in .env or pass it as an argument."
	@exit 1
endif
	balena tunnel $(UUID) -p 22222:$(LOCAL_SSH_PORT) & echo $$! > .pidfile1
	@sleep 3
	ssh -N -o StrictHostKeyChecking=no -p $(LOCAL_SSH_PORT) -L $(LOCAL_HTTP_PORT):localhost:$(PORT) $(USERNAME)@localhost & echo $$! > .pidfile2
	@sleep 3
	@echo "Launching web interface via http://localhost:$(LOCAL_HTTP_PORT)..."
	@open http://localhost:$(LOCAL_HTTP_PORT)

.PHONY: tailnet
tailnet:
ifeq ($(TAILNET),)
	@echo "TAILNET is not set. Please set it in .env or pass it as an argument."
	@exit 1
endif
ifeq ($(HOSTNAME),)
	@echo "HOSTNAME is not set. Please set it in .env or pass it as an argument."
	@exit 1
endif
	@echo "Launching web interface via https://$(HOSTNAME).$(TAILNET)..."
	@open https://$(HOSTNAME).$(TAILNET)

.PHONY: stop
stop:
	-@kill `cat .pidfile1 2>/dev/null` 2>/dev/null ; rm -f .pidfile1
	-@kill `cat .pidfile2 2>/dev/null` 2>/dev/null ; rm -f .pidfile2

.PHONY: duplicati-tunnel
duplicati-tunnel:
	@$(MAKE) tunnel PORT=8200

.PHONY: jellyfin-tunnel
jellyfin-tunnel:
	@$(MAKE) tunnel PORT=8096

.PHONY: netdata-tunnel
netdata-tunnel:
	@$(MAKE) tunnel PORT=19999

.PHONY: nginx-tunnel
nginx-tunnel:
	@$(MAKE) tunnel PORT=81

.PHONY: nzbhydra-tunnel
nzbhydra-tunnel:
	@$(MAKE) tunnel PORT=5076

.PHONY: ombi-tunnel
ombi-tunnel:
	@$(MAKE) tunnel PORT=3579

.PHONY: overseerr-tunnel
overseerr-tunnel:
	@$(MAKE) tunnel PORT=5055

.PHONY: plex-tunnel
plex-tunnel:
	@$(MAKE) tunnel PORT=32400

.PHONY: radarr-tunnel
radarr-tunnel:
	@$(MAKE) tunnel PORT=7878

.PHONY: sabnzbd-tunnel
sabnzbd-tunnel:
	@$(MAKE) tunnel PORT=8080

.PHONY: sonarr-tunnel
sonarr-tunnel:
	@$(MAKE) tunnel PORT=8989

.PHONY: syncthing-tunnel
syncthing-tunnel:
	@$(MAKE) tunnel PORT=8384

.PHONY: tautulli-tunnel
tautulli-tunnel:
	@$(MAKE) tunnel PORT=8181
