FROM golang:alpine3.14
WORKDIR /go/src
RUN apk update \
  && apk add git upx \
  && git clone https://git.sr.ht/~migadu/alps \
  && cd alps \
  && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags "-s -w" -o alps ./cmd/alps \
  && upx --lzma alps \
  && chmod +x alps

FROM alpine:latest
WORKDIR /app
COPY --from=0 /go/src/alps/alps .
COPY --from=0 /go/src/alps/plugins ./plugins
COPY --from=0 /go/src/alps/themes ./themes

ENTRYPOINT ["/app/alps"]
