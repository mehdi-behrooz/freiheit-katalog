# syntax=docker/dockerfile:1

FROM nginx:1.27-alpine

RUN apk update
RUN apk add gettext         # for: envsubst
RUN apk add jq              # for: jq
RUN apk add curl            # for: curl
RUN apk add bash

COPY --chmod=755 ./entrypoint.sh /docker-entrypoint.d/
COPY --chmod=755 ./generate-configs.sh /usr/bin/
COPY ./conf/ /etc/nginx/templates/
COPY ./www/ /www/

ENV LOG_LEVEL=debug
ENV CONFIG_PATH=/

EXPOSE 80

HEALTHCHECK  --interval=15m \
    --start-interval=30s \
    --start-period=30s \
    CMD curl -fs http://localhost:80/${CONFIG_PATH} || exit 1
