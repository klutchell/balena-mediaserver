# balena-mediaserver

Manage your media server on balena.io

## Services

- [Plex](https://docs.linuxserver.io/images/docker-plex)
- [Jellyfin](https://docs.linuxserver.io/images/docker-jellyfin)
- [NZBGet](https://docs.linuxserver.io/images/docker-nzbget)
- [Sonarr](https://docs.linuxserver.io/images/docker-sonarr)
- [Radarr](https://docs.linuxserver.io/images/docker-radarr)
- [Prowlarr](https://docs.linuxserver.io/images/docker-prowlarr)
- [NZBHydra](https://docs.linuxserver.io/images/docker-nzbhydra)
- [Ombi](https://docs.linuxserver.io/images/docker-ombi)
- [Overseerr](https://docs.linuxserver.io/images/docker-overseerr)
- [Tailscale](https://github.com/klutchell/balena-tailscale)
- [Netdata](https://hub.docker.com/r/netdata/netdata)
- [Duplicati](https://docs.linuxserver.io/images/docker-duplicati)
- [Syncthing](https://docs.linuxserver.io/images/docker-syncthing)
- [Nginx Proxy Manager](https://nginxproxymanager.com/)

## Requirements

- Intel-NUC or similar AMD64 device supported by balenaCloud
- Large primary disk for media storage

## Getting Started

You can one-click-deploy this project to balena using the button below:

[![deploy button](https://balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/klutchell/balena-mediaserver)

## Manual Deployment

Alternatively, deployment can be carried out by manually creating a [balenaCloud account](https://dashboard.balena-cloud.com) and application, flashing a device,
downloading the project and pushing it via the [balena CLI](https://github.com/balena-io/balena-cli).

## Usage

### Device Variables

Device Variables apply to all services within the application, and can be applied fleet-wide to apply to multiple devices.

- `TZ`: Inform services of the [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) in your location

### Nginx Proxy Manager

The default credentials are `admin@example.com:changeme` and you will be prompted to update them after logging in.

Create Proxy Hosts for each desired domain -> service:port.

The hostname and port of each service can be found in the compose file.

### Plex

Obtain a claim token from <https://plex.tv/claim> and set the `PLEX_CLAIM` environment variable.

Create new libraries by pointing to the respective folders in `/downloads/`.

### Jellyfin

Set `JELLYFIN_PublishedServerUrl` to the public URL of your server.

### Nzbget

The default credentials are `nzbget:tegbzn6789` and can be changed under _Settings->Security_.

The root download path should be `/downloads/nzbget` and categories can be created below that.

### Sonarr

The base path should be set to `/downloads/tv`.

### Radarr

The base path should be set to `/downloads/movies`.

### Netdata

Run `ls -nd /var/run/balena.sock | awk '{print $4}'` in a Host OS terminal and set the `PGID` environment variable.

### Duplicati

Configure a new backup by adding sources from `/volumes/`.

## Contributing

Please open an issue or submit a pull request with any features, fixes, or changes.
