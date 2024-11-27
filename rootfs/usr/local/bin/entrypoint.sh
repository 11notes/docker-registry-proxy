#!/bin/ash
  if [ ! -f "${APP_ROOT}/ssl/default.crt" ]; then
    openssl req -x509 -newkey rsa:4096 -subj "/C=XX/ST=XX/L=XX/O=XX/OU=XX/CN=${APP_NAME}" \
      -keyout "${APP_ROOT}/ssl/default.key" \
      -out "${APP_ROOT}/ssl/default.crt" \
      -days 3650 -nodes -sha256 &> /dev/null
  fi

  if [ -z "${1}" ]; then
    if [ ! -z "${REGISTRY_PROXY_CONFIG}" ]; then
      elevenLogJSON info "setting custom ${APP_NAME} config"
      echo "${REGISTRY_PROXY_CONFIG}" > ${APP_ROOT}/etc/config.yaml
    fi    
    elevenLogJSON info "starting ${APP_NAME} v${APP_VERSION}"
    set -- "registry" \
      serve \
      ${APP_ROOT}/etc/config.yaml
  fi

  exec "$@"