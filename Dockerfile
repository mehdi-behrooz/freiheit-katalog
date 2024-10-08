# syntax=docker/dockerfile:1
# checkov:skip=CKV_DOCKER_3: nginx wants to be run as root

FROM nginx:1.27-alpine

RUN apk update \
    && apk add bash curl jq gettext-envsubst

COPY --chmod=755 ./entrypoint.sh /docker-entrypoint.d/
COPY ./conf/ /etc/nginx/templates/

ENV LOG_LEVEL=debug
ENV CONFIG_PATH=/
ENV ENCODE_CONFIG=true

EXPOSE 80

HEALTHCHECK  --interval=15m \
    --start-period=30s \
    --start-interval=10s \
    CMD curl -fs http://localhost:80/${CONFIG_PATH} || exit 1
