FROM alpine:3.4
MAINTAINER AlbinoDrought <albinodrought@gmail.com>

RUN apk add --no-cache ca-certificates bash curl
COPY deploy.sh /usr/local/

ENTRYPOINT ["/usr/local/deploy.sh"]
