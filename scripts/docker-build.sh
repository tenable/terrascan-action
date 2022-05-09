#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

DOCKER_REPO="tenable/terrascan-action"
LATEST_TAG=$(git describe --abbrev=0 --tags)
LATEST_TAG_SHORT=$(echo "${LATEST_TAG//v}")

# Builds image with two tags ( :latest & :<TAG_NAME> )
docker build -t ${DOCKER_REPO}:latest -t ${DOCKER_REPO}:${LATEST_TAG_SHORT} .
