#!/bin/bash

set -euxo pipefail

docker run \
     --rm \
     --volume "$(pwd)/:/src" \
     --workdir "/src/" \
     swift-lambda \
     scripts/package.sh SwiftPasskeyAuthorizer

docker run \
     --rm \
     --volume "$(pwd)/:/src" \
     --workdir "/src/" \
     swift-lambda \
     scripts/package.sh SwiftPasskeyServer
