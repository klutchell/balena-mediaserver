# balena-mediaserver

Manage your media server on balena.io

- [What You'll Need](#what-youll-need)
- [Getting Started](#getting-started)
- [Manual Deployment](#manual-deployment)
- [Usage](#usage)
  - [Environment Variables](#environment-variables)
  - [Networking](#networking)
  - [Tailscale](#tailscale)
  - [Nginx Proxy Manager](#nginx-proxy-manager)
- [Services](#services)
  - [Duplicati](#duplicati)
  - [Jellyfin](#jellyfin)
  - [Netdata](#netdata)
  - [Nzbhydra](#nzbhydra)
  - [Ombi](#ombi)
  - [Overseerr](#overseerr)
  - [Plex](#plex)
  - [Prowlarr](#prowlarr)
  - [Radarr](#radarr)
  - [Sabnzbd](#sabnzbd)
  - [Sonarr](#sonarr)
  - [Syncthing](#syncthing)
  - [Tautulli](#tautulli)
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

### Networking

All services are sharing a single network stack via `network_mode: service:proxy` so they must all expose
unique ports to avoid conflicts.

This method was chosen to put all services on the same Tailnet, without exposing the ports on the host firewall.

From there it is optional to also assign public HTTPS domains to some services.

### Tailscale

Tailscale is the primary method of connecting to your services securely. You can create a free account [here](https://tailscale.com/).

Authenticate by navigating to the auth URL shown in the Tailscale service logs or by providing the `TAILSCALE_AUTHKEY`
environment variable.

All services will be exposed on the same Tailnet node via their unique ports, e.g. `https://mediaserver.tailxxxxx.ts.net:32400`.

Read more at <https://hub.docker.com/r/tailscale/tailscale>.

### Nginx Proxy Manager

Optionally services can also be exposed via HTTPS on a public-facing domain, e.g. `https://plex.mydomain.tld`.

An SSH tunnel can be used for initial access to the proxy manager dashboard.

```text
ssh -p 22222 -L 8080:localhost:81 <balena_username>@<server-public-ip>
```

> If the SSH port is unavailable behind a firewall or NAT, see the [Tailscale](#tailscale) section.

Now the proxy manager dashboard should be available at <http://localhost:8080> and you can start setting up remote proxy
hosts.

The default credentials are below and you will be prompted to update them after logging in.

```text
Email: admin@example.com
Password: changeme
```

For each service you would like to access publicly via your personal domain and HTTPS:

1. Hosts -> Proxy Hosts -> Add Proxy Host
2. Add your personal domain/subdomain to Domain Names (DNS must already be configured with your provider)
3. Scheme, Forward Hostname, and Forward Port can be found in the service descriptions below, e.g. `http` -> `localhost` -> `32400`
4. Optionally create/select an Access List to restrict access
5. Under the SSL tab select `Request a new SSL Certificate` unless you already created one and agree to the TOS

To create a public URL for the Nginx Proxy Manager dashboard itself you would use `http` -> `localhost` -> `81`.

Read more at <https://nginxproxymanager.com/>.

## Services

### Duplicati

Available via `http://localhost:8200` on the `service:proxy` network or port `8200` on your Tailnet.

Configure a new backup by adding sources from `/volumes/`.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-duplicati>.

### Jellyfin

Available via `http://localhost:8096` on the `service:proxy` network or port `8096` on all interfaces.

Set `JELLYFIN_PublishedServerUrl` to the public URL of your server.

Create new libraries by pointing to the respective folders in `/downloads/`.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-jellyfin>.

### Netdata

Available via `http://localhost:19999` on the `service:proxy` network or port `19999` on your Tailnet.

Run `ls -nd /var/run/balena.sock | awk '{print $4}'` in a Host OS terminal and set the `PGID` environment variable.

Read more at <https://hub.docker.com/r/netdata/netdata>.

### Nzbhydra

Available via `http://localhost:5076` on the `service:proxy` network or port `5076` on your Tailnet.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-nzbhydra>.

### Ombi

Available via `http://localhost:3579` on the `service:proxy` network or port `3579` on your Tailnet.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-ombi>.

### Overseerr

Available via `http://localhost:5055` on the `service:proxy` network or port `5055` on your Tailnet.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-overseerr>.

### Plex

Available via `http://localhost:32400` on the `service:proxy` network or port `32400` on all interfaces.

Obtain a claim token from <https://plex.tv/claim> and set the `PLEX_CLAIM` environment variable.

Create new libraries by pointing to the respective folders in `/downloads/`.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-plex>.

### Prowlarr

Available via `http://localhost:9696` on the `service:proxy` network or port `9696` on your Tailnet.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-prowlarr>.

### Radarr

Available via `http://localhost:7878` on the `service:proxy` network or port `7878` on your Tailnet.

The base path should be set to `/downloads/movies`.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-radarr>.

### Sabnzbd

Available via `http://localhost:8080` on the `service:proxy` network or port `8080` on your Tailnet.

You can temporarily bypass the [hostname verification](https://sabnzbd.org/wiki/extra/hostname-check.html) by
opening an SSH tunnel to add credentials or add URLs to the `host_whitelist`.

```text
ssh -p 22222 -L 8080:localhost:8080 <balena_username>@<server-public-ip>
```

The temporary download folder should be `/downloads/sabnzbd/incomplete` and `/downloads/sabnzbd/complete` for completed.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-sabnzbd>.

### Sonarr

Available via `http://localhost:8989` on the `service:proxy` network or port `8989` on your Tailnet.

The base path should be set to `/downloads/tv`.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-sonarr>.

### Syncthing

Available via `http://localhost:8384` on the `service:proxy` network or port `8384` on your Tailnet.

Configure a new sync by adding sources from `/volumes/`.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-syncthing>.

### Tautulli

Available via `http://localhost:8181` on the `service:proxy` network or port `8181` on your Tailnet.

The Plex IP Address or Hostname can just be `localhost` and port `32400` for direct access.

This service can be disabled by setting the `DISABLE` service variable to any non-empty value.

Read more at <https://docs.linuxserver.io/images/docker-tautulli>.

## Contributing

Please open an issue or submit a pull request with any features, fixes, or changes.
