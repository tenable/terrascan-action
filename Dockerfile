# Dependency Image
FROM accurics/terrascan:1.3.2 as terrascan

# Base Image
FROM alpine:3.13.1

# Install Terrascan
COPY --from=terrascan /go/bin/terrascan /usr/bin/
RUN terrascan init

# Handles entrypoint
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
