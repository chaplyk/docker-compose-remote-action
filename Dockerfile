FROM docker/compose:latest

RUN apk add openssh-client

COPY --chmod=0755 entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
