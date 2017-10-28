#!/bin/sh
. ~/.local/etc/travis-ci-github-token.sh
. ~/.local/etc/docker-hub-bvberkum.sh
travis login --org --github-token $GITHUB_TOKEN
travis env set DOCKER_USERNAME $DOCKER_USERNAME
travis env set DOCKER_PASSWORD $DOCKER_PASSWORD
# Id: x-docker-hub-build-monitor/0.0.1-dev
