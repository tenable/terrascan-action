# Dependency Image
FROM tenable/terrascan:1.17.0 as terrascan

# Base Image
FROM alpine:3.17.0

RUN apk update && \
    apk add --no-cache git openssh

# Install Terrascan
COPY --from=terrascan /go/bin/terrascan /usr/bin/
RUN terrascan init

# Handles entrypoint
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
