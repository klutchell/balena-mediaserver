# balena-mediaserver

Manage your media server on balena.io

- [What You'll Need](#what-youll-need)
- [Getting Started](#getting-started)
- [Manual Deployment](#manual-deployment)
- [Usage](#usage)
  - [Environment Variables](#environment-variables)
  - [Remote Access via Nginx](#remote-access-via-nginx)
  - [Remote Access via Tailscale](#remote-access-via-tailscale)
- [Services](#services)
  - [Duplicati](#duplicati)
  - [Jellyfin](#jellyfin)
  - [Netdata](#netdata)
  - [Nginx Proxy Manager](#nginx-proxy-manager)
  - [Nzbget](#nzbget)
  - [Nzbhydra](#nzbhydra)
  - [Ombi](#ombi)
  - [Overseerr](#overseerr)
  - [Plex](#plex)
  - [Prowlarr](#prowlarr)
  - [Radarr](#radarr)
  - [Sabnzbd](#sabnzbd)
  - [Sonarr](#sonarr)
  - [Syncthing](#syncthing)
- [Contributing](#contributing)

## What You'll Need

- A reasonably powerful device running [balenaOS](https://balena.io/os)
- Enough space in the data partition for your media (external storage not supported)
- A [balenaCloud account](https://dashboard.balena-cloud.com) (optional)
- A [Tailscale account](https://tailscale.com/) for VPN access (optional)
- A public domain name for HTTPS access (optional)

## Getting Started

You can one-click-deploy this project to balena using the button below:

[![deploy button](https://balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/klutchell/balena-mediaserver)

## Manual Deployment

Alternatively, deployment can be carried out by manually creating a [balenaCloud account](https://dashboard.balena-cloud.com) and application, flashing a device,
downloading the project and pushing it via the [balena CLI](https://github.com/balena-io/balena-cli).

## Usage

### Environment Variables

Environment Variables apply to all services within the application, and can be applied fleet-wide to apply to multiple devices.

- `TZ`: Inform services of the [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) in your location

### Remote Access via Nginx

Most services and their ports are intended to be accessed via a reverse proxy, and as such are binding
to localhost instead of public interfaces.

On first setup there are no reverse proxies configured, so an SSH tunnel can be used for initial access
to the proxy manager dashboard.

```text
ssh -p 22222 -L 8080:localhost:81 <balena_username>@<server-public-ip>
```

Now the proxy manager dashboard should be available at <http://localhost:8080> and you can start [setting up remote proxy
hosts](#nginx-proxy-manager).

> If the SSH port is unavailable behind a firewall or NAT, see [Remote Access via Tailscale](#remote-access-via-tailscale).

### Remote Access via Tailscale

A secure method of accessing your services remotely is via Tailscale.

Authenticate by navigating to the auth URL shown in the Tailscale service logs or by providing the `TAILSCALE_AUTHKEY`
environment variable.

The ports for each service will be automatically shared on your Tailnet via the [tailscale serve command](https://tailscale.com/kb/1242/tailscale-serve/).

You can see all the current proxies by running `tailscale serve status` in the Tailscale service web terminal.

Read more at <https://hub.docker.com/r/tailscale/tailscale>.

## Services

### Duplicati

Available via `http://duplicati:8200` internally or port `8200` on your Tailnet.

Configure a new backup by adding sources from `/volumes/`.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-duplicati>.

### Jellyfin

Available via `http://jellyfin:8096` internally and port `8096` on all interfaces.

Set `JELLYFIN_PublishedServerUrl` to the public URL of your server.

Create new libraries by pointing to the respective folders in `/downloads/`.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-jellyfin>.

### Netdata

Available via `http://netdata:19999` internally or port `19999` on your Tailnet.

Run `ls -nd /var/run/balena.sock | awk '{print $4}'` in a Host OS terminal and set the `PGID` environment variable.

Read more at <https://hub.docker.com/r/netdata/netdata>.

### Nginx Proxy Manager

Available via `http://proxy:81` internally or port `81` on your Tailnet.

The default credentials are below and you will be prompted to update them after logging in.

```text
Email: admin@example.com
Password: changeme
```

For each service you would like to access publicly via your personal domain and HTTPS:

1. Hosts -> Proxy Hosts -> Add Proxy Host
2. Add your personal domain/subdomain to Domain Names (DNS must already be configured with your provider)
3. Scheme, Forward Hostname, and Forward Port can be found in the service descriptions below, e.g. `http` -> `plex` -> `32400`
4. Optionally create/select an Access List to restrict access
5. Under the SSL tab select `Request a new SSL Certificate` unless you already created one and agree to the TOS

To create a public URL for the Nginx Proxy Manager dashboard itself you would use `http` -> `localhost` -> `81`.

This is not required for all services, only ones you wish to access via HTTPS on a personal domain.

Tailscale can be used in addition to, or instead of, a public-facing URL, on a per-service basis.
For example, you might want Plex to be public at `https://plex.mydomain.tld` but Duplicati to only be available on your Tailnet.

Read more at <https://nginxproxymanager.com/>.

### Nzbget

Available via `http://nzbget:6789` internally or port `6789` on your Tailnet.

The default credentials are below and can be changed under _Settings->Security_.

```text
Username: nzbget
Password: tegbzn6789
```

The root download path should be `/downloads/nzbget` and categories can be created below that.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-nzbget>.

### Nzbhydra

Available via `http://nzbhydra:5076` internally or port `5076` on your Tailnet.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-nzbhydra>.

### Ombi

Available via `http://ombi:3579` internally or port `3579` on your Tailnet.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-ombi>.

### Overseerr

Available via `http://overseerr:5055` internally or port `5055` on your Tailnet.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-overseerr>.

### Plex

Available via `http://plex:32400` internally and port `32400` on all interfaces.

Obtain a claim token from <https://plex.tv/claim> and set the `PLEX_CLAIM` environment variable.

Create new libraries by pointing to the respective folders in `/downloads/`.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-plex>.

### Prowlarr

Available via `http://prowlarr:9696` internally or port `9696` on your Tailnet.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-prowlarr>.

### Radarr

Available via `http://radarr:7878` internally or port `7878` on your Tailnet.

The base path should be set to `/downloads/movies`.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-radarr>.

### Sabnzbd

Available via `http://sabnzbd:8080` internally or port `8080` on your Tailnet.

You can temporarily bypass the [hostname verification](https://sabnzbd.org/wiki/extra/hostname-check.html) by
opening an SSH tunnel to add credentials or add URLs to the `host_whitelist`.

```text
ssh -p 22222 -L 8080:localhost:8080 <balena_username>@<server-public-ip>
```

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-sabnzbd>.

### Sonarr

Available via `http://sonarr:8989` internally or port `8989` on your Tailnet.

The base path should be set to `/downloads/tv`.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-sonarr>.

### Syncthing

Available via `http://syncthing:8384` internally or port `8384` on your Tailnet.

Configure a new sync by adding sources from `/volumes/`.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-syncthing>.

## Contributing

Please open an issue or submit a pull request with any features, fixes, or changes.
