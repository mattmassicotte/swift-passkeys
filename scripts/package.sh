#!/bin/bash

set -euxo pipefail

executable=$1

target=.build/lambda/$executable
rm -rf "$target"
mkdir -p "$target"
cp ".build/release/$executable" "$target/"
cd "$target"
ln -s "$executable" "bootstrap"
zip --symlinks SwiftPasskeysFunction.zip *
