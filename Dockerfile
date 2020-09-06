FROM golang:alpine
LABEL maintainer="Ferdinand Prantl <prantlf@gmail.com>"

RUN apk add --no-cache make patch

ENTRYPOINT ["make"]
CMD ["-h"]
