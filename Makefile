
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

.PHONY: stop
stop:
	-@kill `cat .pidfile1 2>/dev/null` 2>/dev/null ; rm -f .pidfile1
	-@kill `cat .pidfile2 2>/dev/null` 2>/dev/null ; rm -f .pidfile2

.PHONY: tunnel-duplicati
tunnel-duplicati:
	@$(MAKE) tunnel PORT=8200

.PHONY: tunnel-jellyfin
tunnel-jellyfin:
	@$(MAKE) tunnel PORT=8096

.PHONY: tunnel-netdata
tunnel-netdata:
	@$(MAKE) tunnel PORT=19999

.PHONY: tunnel-nginx
tunnel-nginx:
	@$(MAKE) tunnel PORT=81

.PHONY: tunnel-nzbhydra
tunnel-nzbhydra:
	@$(MAKE) tunnel PORT=5076

.PHONY: tunnel-ombi
tunnel-ombi:
	@$(MAKE) tunnel PORT=3579

.PHONY: tunnel-overseerr
tunnel-overseerr:
	@$(MAKE) tunnel PORT=5055

.PHONY: tunnel-plex
tunnel-plex:
	@$(MAKE) tunnel PORT=32400

.PHONY: tunnel-radarr
tunnel-radarr:
	@$(MAKE) tunnel PORT=7878

.PHONY: tunnel-sabnzbd
tunnel-sabnzbd:
	@$(MAKE) tunnel PORT=8080

.PHONY: tunnel-sonarr
tunnel-sonarr:
	@$(MAKE) tunnel PORT=8989

.PHONY: tunnel-syncthing
tunnel-syncthing:
	@$(MAKE) tunnel PORT=8384

.PHONY: tunnel-tautulli
tunnel-tautulli:
	@$(MAKE) tunnel PORT=8181
