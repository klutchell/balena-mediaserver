
include .env
export

LOCAL_SSH_PORT ?= 4321
LOCAL_HTTP_PORT ?= 8080

.PHONY: tunnel
tunnel:
ifeq ($(USE_TAILNET),)
	@$(MAKE) stop
	balena tunnel $(UUID) -p 22222:$(LOCAL_SSH_PORT) & echo $$! > .pidfile1
	@sleep 3
	ssh -N -p $(LOCAL_SSH_PORT) -L $(LOCAL_HTTP_PORT):localhost:$(PORT) $(USERNAME)@localhost & echo $$! > .pidfile2
	@sleep 3
	@echo "Launching web interface via http://localhost:$(LOCAL_HTTP_PORT)..."
	@open http://localhost:$(LOCAL_HTTP_PORT)
else
ifeq ($(HOSTNAME),)
	@echo "Apologies, Tailnet access is not supported for this service!"
	@echo "Apply USE_TAILNET= to use SSH tunnels instead."
else
	@echo "Launching web interface via https://$(HOSTNAME).$(TAILNET)..."
	@open https://$(HOSTNAME).$(TAILNET)
endif
endif

.PHONY: stop
stop:
	-@kill `cat .pidfile1` 2>/dev/null ; rm -f .pidfile1
	-@kill `cat .pidfile2` 2>/dev/null ; rm -f .pidfile2

.PHONY: duplicati-web
duplicati-web:
	@$(MAKE) tunnel PORT=8200 HOSTNAME=mediaserver-duplicati

.PHONY: jellyfin-web
jellyfin-web:
	@$(MAKE) tunnel PORT=8096 HOSTNAME=mediaserver-jellyfin

.PHONY: netdata-web
netdata-web:
	@$(MAKE) tunnel PORT=19999 HOSTNAME=

.PHONY: nginx-web
nginx-web:
	@$(MAKE) tunnel PORT=81 HOSTNAME=

.PHONY: nzbhydra-web
nzbhydra-web:
	@$(MAKE) tunnel PORT=5076 HOSTNAME=mediaserver-nzbhydra

.PHONY: ombi-web
ombi-web:
	@$(MAKE) tunnel PORT=3579 HOSTNAME=mediaserver-ombi

.PHONY: overseerr-web
overseerr-web:
	@$(MAKE) tunnel PORT=5055 HOSTNAME=mediaserver-overseerr

.PHONY: plex-web
plex-web:
	@$(MAKE) tunnel PORT=32400 HOSTNAME=mediaserver-plex

.PHONY: radarr-web
radarr-web:
	@$(MAKE) tunnel PORT=7878 HOSTNAME=mediaserver-radarr

.PHONY: sabnzbd-web
sabnzbd-web:
	@$(MAKE) tunnel PORT=8080 HOSTNAME=mediaserver-sabnzbd

.PHONY: sonarr-web
sonarr-web:
	@$(MAKE) tunnel PORT=8989 HOSTNAME=mediaserver-sonarr

.PHONY: syncthing-web
syncthing-web:
	@$(MAKE) tunnel PORT=8384 HOSTNAME=mediaserver-syncthing

.PHONY: tautulli-web
tautulli-web:
	@$(MAKE) tunnel PORT=8181 HOSTNAME=mediaserver-tautulli
