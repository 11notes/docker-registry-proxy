![Banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# registry-proxy
[<img src="https://img.shields.io/badge/github-source-blue?logo=github">](https://github.com/11notes/docker-registry-proxy/tree/2.8.3) ![size](https://img.shields.io/docker/image-size/11notes/registry-proxy/2.8.3?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/registry-proxy/2.8.3?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/registry-proxy?color=2b75d6)

**Run your own Docker registry proxy**

# SYNOPSIS
**What can I do with this?** With this image all your offline docker nodes can still request and pull all images available at hub.docker.com. Simply put this image behind your favourite reverse HTTPS proxy and point all nodes via `/etc/docker/daemon.json >> "registry-mirrors": ["https://docker.domain.com"]` to this proxy. Your offline docker nodes can now successfully pull all public images available. Registry mirrors can be daisy chained, so that the first mirror will pull and hold all public images, and the next mirror would be a private one.

# COMPOSE
```yaml
name: "registry-proxy"
services:
  registry-proxy:
    image: "11notes/registry-proxy:2.8.3"
    container_name: "registry-proxy"
    environment:
      TZ: Europe/Zurich
      REGISTRY_PROXY_CONFIG: |-
        version: 0.1
        log:
          accesslog:
            disabled: false
          level: warn
          formatter: json
          fields:
            service: registry
        storage:
          cache:
            blobdescriptor: inmemory
            blobdescriptorsize: 0
          filesystem:
            rootdirectory: /registry-proxy/var
          maintenance:
            uploadpurging:
              enabled: true
              age: 168h
              interval: 24h
              dryrun: false
        http:
          addr: 0.0.0.0:5000
          net: tcp
          tls:
            certificate: /registry-proxy/ssl/default.crt
            key: /registry-proxy/ssl/default.key
          headers:
            X-Content-Type-Options: [nosniff]
        health:
          storagedriver:
            enabled: true
            interval: 10s
            threshold: 3
        proxy:
          remoteurl: https://registry-1.docker.io
          ttl: 168h
    ports:
      - "5000:5000/tcp"
    volumes:
      - "var:/registry-proxy/var"
    restart: always
volumes:
  var:
```

# DEFAULT SETTINGS
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /registry-proxy | home directory of user docker |

# ENVIRONMENT
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Show debug information | |

# SOURCE
* [11notes/registry-proxy:2.8.3](https://github.com/11notes/docker-registry-proxy/tree/2.8.3)

# PARENT IMAGE
* [registry:2.8.3](https://hub.docker.com/_/registry)

# BUILT WITH
* [keeweb](https://keeweb.info)
* [alpine](https://alpinelinux.org)

# TIPS
* Use a reverse proxy like Traefik, Nginx to terminate TLS with a valid certificate
* Use Let’s Encrypt certificates to protect your SSL endpoints

# ElevenNotes<sup>™️</sup>
This image is provided to you at your own risk. Always make backups before updating an image to a different version. Check the [RELEASE.md](https://github.com/11notes/docker-registry-proxy/blob/2.8.3/RELEASE.md) for breaking changes. You can find all my repositories on [github](https://github.com/11notes).