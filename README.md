# balena-mediaserver

Manage your media server on balena.io

- [What You'll Need](#what-youll-need)
- [Getting Started](#getting-started)
- [Manual Deployment](#manual-deployment)
- [Usage](#usage)
  - [Environment Variables](#environment-variables)
  - [Remote Access via SSH Tunnel](#remote-access-via-ssh-tunnel)
  - [Remote Access via Tailscale](#remote-access-via-tailscale)
  - [Remote Access via Nginx](#remote-access-via-nginx)
- [Services](#services)
  - [Duplicati](#duplicati)
  - [Jellyfin](#jellyfin)
  - [Netdata](#netdata)
  - [Nginx Proxy Manager](#nginx-proxy-manager)
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
- A [Tailscale account](https://tailscale.com/) for [Tailnet access](#remote-access-via-tailscale) (optional)
- A custom domain name for [HTTPS access](#remote-access-via-nginx) (optional)

## Getting Started

You can one-click-deploy this project to balena using the button below:

[![deploy button](https://balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/klutchell/balena-mediaserver)

## Manual Deployment

Alternatively, deployment can be carried out by manually creating a [balenaCloud account](https://dashboard.balena-cloud.com) and application, flashing a device, downloading the project and pushing it via the [balena CLI](https://github.com/balena-io/balena-cli).

## Usage

### Environment Variables

Environment Variables can be applied to all services in an application, or only one service, and can be applied fleet-wide to apply to multiple devices.

- `TZ`: Inform services of the [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) in your location.
- `TAILSCALE_AUTHKEY`: The authkey for your tailnet. You can create one in the [admin panel](https://login.tailscale.com/admin/settings/keys).

### Remote Access via SSH Tunnel

Create an SSH tunnel to securely access services without exposing ports or public domains.
This is addition to the other access methods, and is entirely optional.

```bash
# create an VPN tunnel over the balena proxy
balena tunnel ${UUID} -p 22222:4321

# in another window, forward the web service ports over SSH to your localhost
ssh -N -p 4321 -L 8080:localhost:${PORT} ${USERNAME}@localhost
```

Where `UUID` is the UUID of your balena device,
`USERNAME` is your balenaCloud username,
and `PORT` is the service port found under [Services](#services).

Then direct your browser to `http://localhost:8080` to access the web interface.

Optionally, for convenience you can clone this repo and run `make ${SERVICE}-web` after creating
an `.env` file containing `UUID=****` and `USERNAME=****`.

### Remote Access via Tailscale

A secure method of accessing your services remotely is via Tailscale.
This is addition to the other access methods, and is entirely optional.

Authenticate by providing the `TAILSCALE_AUTHKEY` environment variable.

You can create an authkey in the [admin panel](https://login.tailscale.com/admin/settings/keys).
See [here](https://tailscale.com/kb/1085/auth-keys/) for more information about authkeys and what you can do with them.

Once authenticated, each service will be added to your Tailnet with the name shown under [Services](#services).

Read more at <https://tailscale.dev/blog/docker-mod-tailscale>.

### Remote Access via Nginx

Custom domains can be used with TLS certificates to expose any services via HTTPS reverse proxy.
This is addition to the other access methods, and is entirely optional.

For each service you would like to access publicly via your personal domain and HTTPS:

1. Select **Hosts** -> **Proxy Hosts** -> **Add Proxy Host**
2. Add your personal domain/subdomain to **Domain Names** (DNS must already be configured with your provider)
3. **Scheme** should always be `http` for the backend.
4. **Forward Hostname** will be the name of the service to proxy, e.g. `plex`
5. **Forward Port** can be found in the service description under [Services](#services), e.g. `32400`
6. Optionally create/select an Access List for security
7. Under the **SSL** tab select `Request a new SSL Certificate` unless you already created one and agree to the TOS

To create a public URL for the Nginx Proxy Manager dashboard itself you would use `http` -> `localhost` -> `81`.

Read more at <https://nginxproxymanager.com/>.

## Services

### Duplicati

The web interface is available via port `8200` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via `mediaserver-duplicati` on your [Tailnet](#remote-access-via-tailscale),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

Configure a new backup by adding sources from `/volumes/`.

This service can be disabled by setting the `DISABLE` service variable to a truthy value.

Read more at <https://docs.linuxserver.io/images/docker-duplicati>.

### Jellyfin

The web interface is available via port `8096` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via `mediaserver-jellyfin` on your [Tailnet](#remote-access-via-tailscale),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

Set `JELLYFIN_PublishedServerUrl` to the public URL of your server.

Create new libraries by pointing to the respective folders in `/downloads/`.

This service can be disabled by setting the `DISABLE` service variable to a truthy value.

Read more at <https://docs.linuxserver.io/images/docker-jellyfin>.

### Netdata

The web interface is available via port `19999` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

Run `ls -nd /var/run/balena.sock | awk '{print $4}'` in a Host OS terminal and set the `PGID` environment variable.

Read more at <https://hub.docker.com/r/netdata/netdata>.

### Nginx Proxy Manager

The web interface is available via port `81` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via `mediaserver-nginx` on your [Tailnet](#remote-access-via-tailscale),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

The default credentials are below and you will be prompted to update them after logging in.

```text
Email: admin@example.com
Password: changeme
```

Read more at <https://nginxproxymanager.com/>.

### Nzbhydra

The web interface is available via port `5076` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via `mediaserver-nzbhydra` on your [Tailnet](#remote-access-via-tailscale),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

This service can be disabled by setting the `DISABLE` service variable to a truthy value.

Read more at <https://docs.linuxserver.io/images/docker-nzbhydra>.

### Ombi

The web interface is available via port `3579` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via `mediaserver-ombi` on your [Tailnet](#remote-access-via-tailscale),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

This service can be disabled by setting the `DISABLE` service variable to a truthy value.

Read more at <https://docs.linuxserver.io/images/docker-ombi>.

### Overseerr

The web interface is available via port `5055` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via `mediaserver-overseerr` on your [Tailnet](#remote-access-via-tailscale),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

This service can be disabled by setting the `DISABLE` service variable to a truthy value.

Read more at <https://docs.linuxserver.io/images/docker-overseerr>.

### Plex

The web interface is available via port `32400` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via `mediaserver-plex` on your [Tailnet](#remote-access-via-tailscale),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

Obtain a claim token from <https://plex.tv/claim> and set the `PLEX_CLAIM` environment variable.

Create new libraries by pointing to the respective folders in `/downloads/`.

This service can be disabled by setting the `DISABLE` service variable to a truthy value.

Read more at <https://docs.linuxserver.io/images/docker-plex>.

### Prowlarr

The web interface is available via port `9696` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via `mediaserver-prowlarr` on your [Tailnet](#remote-access-via-tailscale),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

This service can be disabled by setting the `DISABLE` service variable to a truthy value.

Read more at <https://docs.linuxserver.io/images/docker-prowlarr>.

### Radarr

The web interface is available via port `7878` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via `mediaserver-radarr` on your [Tailnet](#remote-access-via-tailscale),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

The base path should be set to `/downloads/movies`.

This service can be disabled by setting the `DISABLE` service variable to a truthy value.

Read more at <https://docs.linuxserver.io/images/docker-radarr>.

### Sabnzbd

The web interface is available via port `8080` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via `mediaserver-sabnzbd` on your [Tailnet](#remote-access-via-tailscale),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

The temporary download folder should be `/downloads/sabnzbd/incomplete` and `/downloads/sabnzbd/complete` for completed.

This service can be disabled by setting the `DISABLE` service variable to a truthy value.

Read more at <https://docs.linuxserver.io/images/docker-sabnzbd>.

### Sonarr

The web interface is available via port `8989` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via `mediaserver-sonarr` on your [Tailnet](#remote-access-via-tailscale),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

The base path should be set to `/downloads/tv`.

This service can be disabled by setting the `DISABLE` service variable to a truthy value.

Read more at <https://docs.linuxserver.io/images/docker-sonarr>.

### Syncthing

The web interface is available via port `8384` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via `mediaserver-syncthing` on your [Tailnet](#remote-access-via-tailscale),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

Configure a new sync by adding sources from `/volumes/`.

This service can be disabled by setting the `DISABLE` service variable to a truthy value.

Read more at <https://docs.linuxserver.io/images/docker-syncthing>.

### Tautulli

The web interface is available via port `8181` over an [SSH tunnel](#remote-access-via-ssh-tunnel),
or via `mediaserver-tautulli` on your [Tailnet](#remote-access-via-tailscale),
or via a personal HTTPS domain with [Nginx](#remote-access-via-nginx).

The Plex IP Address or Hostname can just be `plex` and port `32400` for direct access.

This service can be disabled by setting the `DISABLE` service variable to a truthy value.

Read more at <https://docs.linuxserver.io/images/docker-tautulli>.

## Contributing

Please open an issue or submit a pull request with any features, fixes, or changes.
