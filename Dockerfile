FROM scratch
ADD ca-certificates.crt /etc/ssl/certs/
ADD assets /fetcher
ADD main /fetcher
ENTRYPOINT ["/fetcher/main", "-assets", "/fetcher"]
