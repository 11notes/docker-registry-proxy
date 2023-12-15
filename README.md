# Alpine :: Docker Registry (proxy)
![size](https://img.shields.io/docker/image-size/11notes/registry-proxy/2.8.3?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/registry-proxy?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/registry-proxy?color=2b75d6) ![activity](https://img.shields.io/github/commit-activity/m/11notes/docker-registry-proxy?color=c91cb8) ![commit-last](https://img.shields.io/github/last-commit/11notes/docker-registry-proxy?color=c91cb8)

Run a Docker registry as a proxy based on Alpine Linux. Small, lightweight, secure and fast 🏔️

## Use Case
With this image all your offline docker nodes can still request and pull all images available at hub.docker.com. Simply put this image behind your favourite reverse HTTPS proxy and point all nodes via `/etc/docker/daemon.json >> "registry-mirrors": ["https://docker.domain.com"]` to this proxy. Your offline docker nodes can now successfully pull all public images available. Registry mirrors can be daisy chained, so that the first mirror will pull and hold all public images, and the next mirror would be a private one.

## Volumes
* **/registry-proxy/var** - Directory of all container images that got pulled by clients

## Run
```shell
docker run --name registry-proxy \
  -v .../var:/registry-proxy/var \
  -d 11notes/registry-proxy:[tag]
```

## Defaults
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /registry-proxy | home directory of user docker |
| `api` | https://${IP}:5000 | HTTPS endpoint of Docker registry |

## Parent image
* [registry:2.8.3](https://hub.docker.com/_/registry)

## Built with and thanks to
* [Docker](https://www.docker.com)
* [Alpine Linux](https://alpinelinux.org)

## Tips
* Only use rootless container runtime (podman, rootless docker)
* Don't bind to ports < 1024 (requires root), use NAT/reverse proxy (haproxy, traefik, registry-proxy)