#!/usr/bin/env bash

set -e

if ! [ -x "$(command -v jazzy)" ]; then
    echo 'Error: jazzy is not installed.' >&2
    echo '       Install using: `gem install jazzy`.' >&2
    exit 1
fi

jazzy \
    --clean \
    --author MAVSDK developers \
    --author_url https://mavsdk.mavlink.io \
    --github_url https://github.com/mavlink/MAVSDK-Swift \
    --github-file-prefix https://github.com/mavlink/MAVSDK-Swift/tree/master \
    --module-version master \
    --root-url https://mavsdk.mavlink.io/docs/swift \
    --output docs/swift_output \
    --module MAVSDK_Swift
