# Dependency Image
FROM accurics/terrascan:1.10.0 as terrascan

# Base Image
FROM alpine:3.14.2

RUN apk update && \
    apk add --no-cache git openssh-client

# Install Terrascan
COPY --from=terrascan /go/bin/terrascan /usr/bin/
RUN terrascan init

# Handles entrypoint
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
