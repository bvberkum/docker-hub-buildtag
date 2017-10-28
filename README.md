# DockerHub buildtag  [![Docker Build Status](http://hubmon.wtwta.org/shield/bvberkum/hubmon)](https://hub.docker.com/r/bvberkum/hubmon)


- Fork of [cpuguy83/docker-hub-buildtag](/cpuguy83/docker-hub-buildtag) updated
- FIXME: Generates build status tags for Dockerhub automated builds as seen above

Usage
```
docker run -d --name redis redis
docker run --link redis:db -d bvberkum/hubmon -redis db:6379
```

To embed the generated badge, see the raw output of this README.md


## Travis
```
travis env set DOCKER_USERNAME myusername
travis env set DOCKER_PASSWORD secretsecret
```
