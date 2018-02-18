#!/bin/sh
set -e

. ./profile.sh
. ./cert-init.sh

test ! -e main || rm main

test -x "$(which go)" && {

  go get github.com/PuerkitoBio/goquery &&
  go get github.com/hoisie/redis &&
  CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main . &&
  docker rmi -f $IMG &&
  docker build -t $IMG .

} || {

  # use golang-builder instead
  docker run --rm \
    -v "$(pwd -P):/src" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    centurylink/golang-builder-cross $IMG
}

. ./hooks/test

# Id: x-docker-hub-build-monitor/0.0.2-dev build.sh
