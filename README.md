# balena-mediaserver

mediaserver stack for balenaCloud

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

|Name|Example|Purpose|
|---|---|---|
|`PLEX_CLAIM`||(optional) obtain a claim token from <https://plex.tv/claim> and input here (claim tokens expire within 4 minutes)|
|`TZ`|`America/Toronto`|(optional) inform services of the [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) in your location|

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

* access the dashboard via `http://<device-ip>:5076`
* make note of your API key under Config->Main->Security
* add your nzb indexers under Config->Indexers
* optionally enable authentication under Config->Authorization

### nzbget

* access the dashboard via `http://<device-ip>:6789`
* default credentials are `nzbget:tegbzn6789`
* add your usenet servers under Settings->News-Servers
* optionally change or remove authentication under Settings->Security
* change Settings->Paths->MainDir to `/media/{UUID}/downloads`

### sonarr

* access the dashboard via `http://<device-ip>:8989`
* add `http://nzbhydra:5076` under Settings->Indexers->Newznab
* add `http://nzbget:6789` under Settings->Download Client
* optionally enable authentication under Settings->General->Security
* when adding your first series set the base path to `/media/{UUID}/tv`

### radarr

* access the dashboard via `http://<device-ip>:7878`
* add `http://nzbhydra:5076` under Settings->Indexers->Newznab
* add `http://nzbget:6789` under Settings->Download Client
* optionally enable authentication under Settings->General->Security
* when adding your first movie set the base path to `/media/{UUID}/movies`

### plex

* set the `PLEX_CLAIM` token and restart the service
* access the dashboard via `http://<device-ip>:32400`
* create a new Movies library pointing to `/media/{UUID}/movies`
* create a new TV Shows library pointing to `/media/{UUID}/tv`

### duplicati

* access the dashboard via `http://<device-ip>:8200`
* configure a new backup using `/source` for Source Data

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
