# Docker Hub Builds

[![](http://img.shields.io/travis/bvberkum/x-docker-hub-build-monitor.svg)](https://travis-ci.org/bvberkum/x-docker-hub-build-monitor)
![repo license](https://img.shields.io/github/license/bvberkum/x-docker-hub-build-monitor.svg)
![commits per year](https://img.shields.io/github/commit-activity/y/bvberkum/x-docker-hub-build-monitor.svg)
![](https://img.shields.io/github/languages/code-size/bvberkum/x-docker-hub-build-monitor.svg)
![](https://img.shields.io/github/repo-size/bvberkum/x-docker-hub-build-monitor.svg)
master: ![latest/master](https://img.shields.io/github/last-commit/bvberkum/x-docker-hub-build-monitor/master.svg) latest: ![image size](https://img.shields.io/imagelayers/image-size/bvberkum/hubmon/latest.svg) ![image layers](https://img.shields.io/imagelayers/layers/bvberkum/hubmon/latest.svg) release: ![](https://img.shields.io/github/tag/bvberkum/x-docker-hub-build-monitor.svg) dev: ![dev](https://img.shields.io/github/last-commit/bvberkum/x-docker-hub-build-monitor/dev.svg) ![image size](https://img.shields.io/imagelayers/image-size/bvberkum/hubmon/dev.svg) ![image layers](https://img.shields.io/imagelayers/layers/bvberkum/hubmon/dev.svg)

Version: 0.0.2-dev

- Fork of [cpuguy83/docker-hub-buildtag](/cpuguy83/docker-hub-buildtag) updated
- Generates build status tags for Dockerhub automated builds
- TODO: cache and write out JSON for build log

Rewrote original project and containerized, with some help from [Building Minimal Docker Containers for Go Applications](https://blog.codeship.com/building-minimal-docker-containers-for-go-applications/)

## Usage
```bash
docker run --rm bvberkum/hubmon -h
```
```bash
docker run -d --name redis redis
docker run --link redis:db -p 8123:80 bvberkum/hubmon -redis db:6379 -cache-timeout 10
```
```markdown
[![alt text](http://localhost:8123/badge/bvberkum/hubmon)](https://hub.docker.com/r/bvberkum/hubmon)
```

## Travis
Source and docs: [travis-ci client](https://github.com/travis-ci/travis.rb)
```bash
ruby -v # check for ruby version
gem install travis -v 1.8.8 --no-rdoc --no-ri 
travis version
travis env set DOCKER_USERNAME myusername
travis env set DOCKER_PASSWORD secretsecret
```
See script at [travis-setenv](travis-setenv.sh)
