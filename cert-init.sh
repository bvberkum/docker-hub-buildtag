#!/bin/sh
set -e

test -e ca-certificates.crt || {
  docker run -v $(pwd -P):/data -t --rm ubuntu:latest bash -c \
        'apt-get update -qqy && apt-get install ca-certificates -qqy && /bin/cp /etc/ssl/certs/ca-certificates.crt /data';
 }

# Id: x-docker-hub-build-monitor/0.0.3-dev cert-init.sh
