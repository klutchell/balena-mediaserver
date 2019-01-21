# balena-mediaserver

armv7hf [balena.io](https://www.balena.io/) stack with the following services:
* [pihole](https://hub.docker.com/r/lsioarmhf/plex)
* [nzbget](https://hub.docker.com/r/lsioarmhf/nzbget)
* [sonarr](https://hub.docker.com/r/lsioarmhf/sonarr)
* [radarr](https://hub.docker.com/r/lsioarmhf/radarr)

## Getting Started

https://www.balena.io/docs/learn/getting-started

## Deployment

### Application Environment Variables

|Name|Value|
|---|---|
|`TZ`|`America/Toronto`|

### Service Variables

|Service|Name|Value|
|---|---|---|
|`plex`|`VERSION`|`latest`|

## Usage

_TODO_

## Author

Kyle Harding <kylemharding@gmail.com>

## License

[MIT License](./LICENSE)

## Acknowledgments

I didn't create any of these docker images myself, so credit goes to the
maintainers, and the app creators.

* [balena.io](https://www.balena.io/)
* [linuxserver.io](https://linuxserver.io/)

## References

* https://www.balena.io/docs/learn/getting-started
* https://github.com/balena-io-projects/multicontainer-getting-started
* https://www.balena.io/docs/learn/develop/runtime/#mounting-external-storage-media


