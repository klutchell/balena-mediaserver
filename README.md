# balena-mediaserver

Manage your media server on balena.io

- [Prerequisites](#prerequisites)
- [Deployment](#deployment)
  - [One-Click Deployment](#one-click-deployment)
  - [Manual Deployment](#manual-deployment)
- [Configuration](#configuration)
  - [Environment Variables](#environment-variables)
  - [Remote Access](#remote-access)
    - [Via Tailscale](#via-tailscale)
    - [Via Nginx](#via-nginx)
- [Services](#services)
  - [Duplicati](#duplicati)
  - [Jellyfin](#jellyfin)
  - [Netdata](#netdata)
  - [Nginx](#nginx)
  - [Nzbhydra](#nzbhydra)
  - [Ombi](#ombi)
  - [Plex](#plex)
  - [Profilarr](#profilarr)
  - [Prowlarr](#prowlarr)
  - [Radarr](#radarr)
  - [Sabnzbd](#sabnzbd)
  - [Sonarr](#sonarr)
  - [Syncthing](#syncthing)
  - [Tautulli](#tautulli)
- [Contributing](#contributing)

## Prerequisites

- A device running [balenaOS](https://balena.io/os) with sufficient processing power
- Adequate storage space in the data partition for your media
- A [balenaCloud account](https://dashboard.balena-cloud.com) (optional)
- A [Tailscale account](https://tailscale.com/) for remote access (optional)
- A custom domain name for HTTPS access (optional)

## Deployment

### One-Click Deployment

[![deploy button](https://balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/klutchell/balena-mediaserver)

### Manual Deployment

1. Create a [balenaCloud account](https://dashboard.balena-cloud.com) and application
2. Flash a device with balenaOS
3. Clone this repository
4. Push the project to your balena application using the [balena CLI](https://github.com/balena-io/balena-cli)

## Configuration

### Environment Variables

Environment Variables can be applied to all services in an application, or only one service, and can be applied fleet-wide to apply to multiple devices.

- `TZ`: Inform services of the [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) in your location.

### Remote Access

#### Via Tailscale

1. Provide the `TS_AUTHKEY` environment variable
2. Access services via `https://${TS_CERT_DOMAIN}:${service_port}`

Read more at <https://tailscale.com/blog/docker-tailscale-guide> and <https://tailscale.com/kb/1282/docker>

#### Via Nginx

1. Add proxy hosts via `http:${service-name}:${service-port}`
2. Set up custom domains and SSL certificates as needed

Read more at <https://nginxproxymanager.com/>

#### Via Docktail

Docktail automatically exposes services via Tailscale based on Docker labels.
Before using Docktail, configure your Tailscale admin console at <https://login.tailscale.com/admin/services>.

1. Create service definitions (Services → Add service):

   Create a service for each application you want to expose with port `443`:

   - `duplicati-mediaserver`
   - `jellyfin`
   - `netdata-mediaserver`
   - `nginx-mediaserver`
   - `nzbhydra`
   - `ombi`
   - `plex`
   - `profilarr`
   - `prowlarr`
   - `radarr`
   - `sabnzbd`
   - `sonarr`
   - `syncthing-mediaserver`
   - `tautulli`

2. (Optional) Configure service tags:

   - Navigate to Access Controls
   - Add tags for service identification (e.g., `tag:mediaserver-service`)
   - Tag your Docker host (e.g., `tag:mediaserver`)

3. (Recommended) Enable auto-approval:

   - Navigate to Access Controls and edit your ACL policy
   - Add auto-approvers to skip manual approval for service advertisements:

   ```json
   {
     "autoApprovers": {
       "services": {
         "tag:mediaserver-service": ["tag:mediaserver"]
       }
     }
   }
   ```

   - This allows devices tagged `tag:mediaserver` to automatically advertise services tagged `tag:mediaserver-service`

Read more at <https://github.com/marvinvr/docktail> and <https://tailscale.com/kb/1552/tailscale-services>

## Services

Each service below includes its forward host and port, along with basic setup instructions.\
Services can be disabled by setting the `DISABLE` environment variable to a truthy value.

### Duplicati

- Forward host and port: `http://duplicati:8200`
- Set a password with the `DUPLICATI__WEBSERVICE_PASSWORD` environment variable
- Configure backups using sources from `/volumes/`

Read more at <https://docs.linuxserver.io/images/docker-duplicati>

### Jellyfin

- Forward host and port: `http://jellyfin:8096`
- Set `JELLYFIN_PublishedServerUrl` to your public server URL
- Create libraries using folders in `/downloads/`

Read more at <https://docs.linuxserver.io/images/docker-jellyfin>

### Netdata

- Forward host and port: `http://netdata:19999`
- Set `PGID` environment variable (see README for details)

Read more at <https://hub.docker.com/r/netdata/netdata>

### Nginx

- Forward host and port: `http://nginx:81`
- Default credentials:
  - Email: `admin@example.com`
  - Password: `changeme`

Read more at <https://nginxproxymanager.com/>

### Nzbhydra

- Forward host and port: `http://nzbhydra:5076`

Read more at <https://docs.linuxserver.io/images/docker-nzbhydra>

### Ombi

- Forward host and port: `http://ombi:3579`

Read more at <https://docs.linuxserver.io/images/docker-ombi>

### Plex

- Forward host and port: `http://plex:32400`
- Set `PLEX_CLAIM` environment variable (obtain from <https://plex.tv/claim>)
- Create libraries using folders in `/downloads/`

Read more at <https://docs.linuxserver.io/images/docker-plex>

### Profilarr

- Forward host and port: `http://profilarr:6868`
- Configuration management tool for Radarr/Sonarr
- Automates importing and version control of custom formats and quality profiles

Read more at <https://dictionarry.dev/profilarr-setup/installation>

### Prowlarr

- Forward host and port: `http://prowlarr:9696`

Read more at <https://docs.linuxserver.io/images/docker-prowlarr>

### Radarr

- Forward host and port: `http://radarr:7878`
- Set base path to `/downloads/movies`

Read more at <https://docs.linuxserver.io/images/docker-radarr>

### Sabnzbd

- Forward host and port: `http://sabnzbd:8080`
- Set download folders:
  - Temporary: `/downloads/sabnzbd/incomplete`
  - Completed: `/downloads/sabnzbd/complete`

Read more at <https://docs.linuxserver.io/images/docker-sabnzbd>

### Sonarr

- Forward host and port: `http://sonarr:8989`
- Set base path to `/downloads/tv`

Read more at <https://docs.linuxserver.io/images/docker-sonarr>

### Syncthing

- Forward host and port: `http://syncthing:8384`
- Configure syncs using sources from `/volumes/`

Read more at <https://docs.linuxserver.io/images/docker-syncthing>

### Tautulli

- Forward host and port: `http://tautulli:8181`
- Set Plex IP Address/Hostname to `plex` and port to `32400`

Read more at <https://docs.linuxserver.io/images/docker-tautulli>

## Contributing

Please open an issue or submit a pull request with any features, fixes, or changes.
