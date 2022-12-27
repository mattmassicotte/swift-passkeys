#!/bin/bash

set -euxo pipefail

executable=$1

swift build --product $executable --static-swift-stdlib -c release

target=.build/lambda/$executable
rm -rf "$target"
mkdir -p "$target"
cp ".build/release/$executable" "$target/"
cd "$target"
ln -s "$executable" "bootstrap"
zip --symlinks "${executable}Function.zip" *
