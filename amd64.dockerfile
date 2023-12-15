# :: Header
  FROM registry:2.8.3
  ENV APP_ROOT=/registry-proxy
  ENV APP_NAME="registry-proxy"

# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --no-cache add \
        curl \
        tzdata \
        shadow \
        openssl; \
      apk --no-cache upgrade;

  # :: create user
    RUN set -ex; \
      addgroup --gid 1000 -S docker; \
      adduser --uid 1000 -D -S -h / -s /sbin/nologin -G docker docker;

  # :: prepare image
    RUN set -ex; \
      mkdir -p ${APP_ROOT}; \
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
  HEALTHCHECK CMD /usr/local/bin/healthcheck.sh

# :: Start
  USER docker
  ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]