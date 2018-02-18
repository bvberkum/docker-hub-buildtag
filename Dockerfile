FROM scratch
ADD ca-certificates.crt /etc/ssl/certs/
ADD assets /fetcher
ARG bin=x-docker-hub-build-monitor-linux-386
COPY $bin /fetcher/main
ENTRYPOINT ["/fetcher/main", "-assets", "/fetcher"]
