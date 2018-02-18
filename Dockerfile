FROM scratch
ADD ca-certificates.crt /etc/ssl/certs/
ADD assets /fetcher
ARG bin=x-docker-hub-build-monitor-linux-386
COPY $bin /fetcher
ENTRYPOINT ["/fetcher/$bin", "-assets", "/fetcher"]
