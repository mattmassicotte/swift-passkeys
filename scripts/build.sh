#!/bin/bash

set -euxo pipefail

docker run \
     --rm \
     --volume "$(pwd)/:/src" \
     --workdir "/src/" \
     swift-lambda \
     swift build --product SwiftPasskeys --static-swift-stdlib -c release

docker run \
     --rm \
     --volume "$(pwd)/:/src" \
     --workdir "/src/" \
     swift-lambda \
     scripts/package.sh SwiftPasskeys