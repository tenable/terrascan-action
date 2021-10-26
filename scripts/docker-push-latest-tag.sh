#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

DOCKER_REPO="accurics/terrascan-action"

docker push ${DOCKER_REPO} --all-tags
