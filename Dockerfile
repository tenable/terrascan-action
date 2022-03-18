# Dependency Image
FROM accurics/terrascan:1.12.0 as terrascan

# Base Image
FROM alpine:3.15.1

RUN apk update && \
    apk add --no-cache git openssh

# Install Terrascan
COPY --from=terrascan /go/bin/terrascan /usr/bin/
RUN terrascan init

# Handles entrypoint
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
