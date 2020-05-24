# balena-mediaserver

mediaserver stack for balenaCloud

## Features

- [Plex](https://plex.tv/) organizes video, music and photos from personal media libraries and streams them to smart TVs, streaming boxes and mobile devices.
- [NZBGet](https://nzbget.net/) is a usenet downloader, written in C++ and designed with performance in mind to achieve maximum download speed by using very little system resources.
- [Sonarr](https://sonarr.tv/) is a PVR for usenet and bittorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
- [Radarr](https://radarr.video/) is a fork of Sonarr to work with movies à la Couchpotato.
- [NZBHydra2](https://github.com/theotherp/nzbhydra2) is a meta search application for NZB indexers, the "spiritual successor" to NZBmegasearcH, and an evolution of the original application NZBHydra.

## Requirements

- Raspberry Pi 4 or a similar x64 device supported by BalenaCloud
- USB storage drive

## Getting Started

To get started you'll first need to sign up for a free balenaCloud account and flash your device.

<https://www.balena.io/docs/learn/getting-started>

## Deployment

Once your account is set up, deployment is carried out by downloading the project and pushing it to your device either via Git or the balenaCLI.

### Application Environment Variables

Application envionment variables apply to all services within the application, and can be applied fleet-wide to apply to multiple devices.

| Name         | Example           | Purpose                                                                                                                     |
| ------------ | ----------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `PLEX_CLAIM` |                   | obtain a claim token from <https://plex.tv/claim> (expires in 4 minutes)                                                    |
| `TZ`         | `America/Toronto` | (optional) inform services of the [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) in your location |

## Usage

### prepare external storage

Connect to the `Host OS` Terminal and run the following:

```bash
# g - create a new empty GPT partition table
# n - add a new partition
# p - primary partition
# 1 - partition number 1
# default - start at beginning of disk
# default - extend partition to end of disk
# w - write the partition table
printf "g\nn\np\n1\n\n\nw\n" | fdisk /dev/sda
mkfs.ext4 /dev/sda1
```

Restart the services and any supported partitions will be mounted at `/media/{UUID}`.

### nzbhydra

- access the dashboard via `http://{HOST}:5076`
- make note of your API key under _Config->Main->Security_
- add your nzb indexers under _Config->Indexers_
- optionally enable authentication under _Config->Authorization_

### nzbget

- access the dashboard via `http://{HOST}:6789`
- default credentials are `nzbget:tegbzn6789`
- add your usenet servers under _Settings->News-Servers_
- optionally change or remove authentication under _Settings->Security_
- change _Settings->Paths->MainDir_ to `/media/{UUID}/downloads`

### sonarr

- access the dashboard via `http://{HOST}:8989`
- add `http://nzbhydra:5076` under _Settings->Indexers->Newznab_
- add `http://nzbget:6789` under _Settings->Download Client_
- optionally enable authentication under _Settings->General->Security_
- when adding your first series set the base path to `/media/{UUID}/tv`

### radarr

- access the dashboard via `http://{HOST}:7878`
- add `http://nzbhydra:5076` under _Settings->Indexers->Newznab_
- add `http://nzbget:6789` under _Settings->Download Client_
- optionally enable authentication under _Settings->General->Security_
- when adding your first movie set the base path to `/media/{UUID}/movies`

### plex

- set the `PLEX_CLAIM` token and restart the service
- access the dashboard via `http://{HOST}:32400`
- create a new Movies library pointing to `/media/{UUID}/movies`
- create a new TV Shows library pointing to `/media/{UUID}/tv`

### duplicati

- access the dashboard via `http://{HOST}:8200`
- configure a new backup using `/source` for Source Data

## Contributing

Please open an issue or submit a pull request with any features, fixes, or changes.

## Author

Kyle Harding <https://klutchell.dev>

[Buy me a beer](https://kyles-tip-jar.myshopify.com/cart/31356319498262:1?channel=buy_button)

[Buy me a craft beer](https://kyles-tip-jar.myshopify.com/cart/31356317859862:1?channel=buy_button)

## Acknowledgments

- <https://hub.docker.com/r/linuxserver/plex>
- <https://hub.docker.com/r/linuxserver/nzbget>
- <https://hub.docker.com/r/linuxserver/sonarr>
- <https://hub.docker.com/r/linuxserver/radarr>
- <https://hub.docker.com/r/linuxserver/nzbhydra2>
- <https://hub.docker.com/r/linuxserver/duplicati>

## License

[MIT License](./LICENSE)
