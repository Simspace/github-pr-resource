FROM golang:1.18.1-alpine3.15 as builder
ENV GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64
WORKDIR /go/src/github.com/telia-oss/github-pr-resource
ADD . /go/src/github.com/telia-oss/github-pr-resource
RUN go build -o build/in -ldflags="-s -w" -v cmd/in/main.go && \
    go build -o build/out -ldflags="-s -w" -v cmd/out/main.go && \
    go build -o build/check -ldflags="-s -w" -v cmd/check/main.go && \
    chmod +x build/*

FROM alpine:3.15.4
COPY scripts/askpass.sh /usr/local/bin/askpass.sh
RUN apk add --update --no-cache \
    git \
    git-lfs \
    openssh
COPY --from=builder /go/src/github.com/telia-oss/github-pr-resource/build /opt/resource
RUN ls -ahl /opt/resource/
