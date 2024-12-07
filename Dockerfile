FROM golang:alpine
LABEL maintainer="Ferdinand Prantl <prantlf@gmail.com>"

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache make patch curl

ENTRYPOINT ["make"]
CMD ["-h"]
