# :: Util
  FROM alpine as util

  RUN set -ex; \
    apk add --no-cache \
      git; \
    git clone https://github.com/11notes/util.git;

# :: Header
  FROM registry:2.8.3
  COPY --from=util /util/docker /usr/local/bin
  ENV APP_NAME="registry-proxy"
  ENV APP_VERSION=2.8.3
  ENV APP_ROOT=/registry-proxy

# :: Run
  USER root

  # :: install binaries required
    RUN set -ex; \
      apk --no-cache add \
        curl \
        tzdata \
        shadow \
        openssl;

  # :: create user
    RUN set -ex; \
      addgroup --gid 1000 -S docker; \
      adduser --uid 1000 -D -S -h / -s /sbin/nologin -G docker docker;

  # :: prepare container file system
    RUN set -ex; \
      mkdir -p ${APP_ROOT}; \
      mkdir -p ${APP_ROOT}/var; \
      mkdir -p ${APP_ROOT}/etc; \
      mkdir -p ${APP_ROOT}/ssl; \
      rm /entrypoint.sh;  

  # :: copy root filesystem changes and add execution rights to init scripts
    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin

  # :: change home path for existing user and set correct permission
    RUN set -ex; \
      usermod -d ${APP_ROOT} docker; \
      chown -R 1000:1000 \
        ${APP_ROOT};

# :: Volumes
  VOLUME ["${APP_ROOT}/var"]

# :: Monitor
  HEALTHCHECK --interval=5s --timeout=2s CMD /usr/local/bin/healthcheck.sh || exit 1

# :: Start
  USER docker
  ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]