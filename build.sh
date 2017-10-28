#!/bin/sh
set -e

test -e ca-certificates.crt || {
  docker run -v $(pwd):/data -t --rm ubuntu:17.04 bash -c \
    'apt-get update -qqy && apt-get install ca-certificates coreutils -qqy && \
    cp /etc/ssl/certs/ca-certificates.crt /data'
}

test ! -e main || rm main

go get github.com/PuerkitoBio/goquery &&
go get github.com/hoisie/redis &&
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main . &&
docker rmi -f hubmon &&
docker build -t hubmon . &&
echo "Starting test server" &&
docker run --link redis:db -ti -p 8123:80 hubmon -redis db:6379 -cache-timeout 10

# Id: x-docker-hub-build-monitor/0.0.1-dev
