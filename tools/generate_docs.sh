#!/usr/bin/env bash

set -e

if ! [ -x "$(command -v jazzy)" ]; then
    echo 'Error: jazzy is not installed.' >&2
    echo '       Install using: `gem install jazzy`.' >&2
    exit 1
fi

jazzy \
    --clean \
    --author Dronecode SDK developers \
    --author_url https://sdk.dronecode.org \
    --github_url https://github.com/Dronecode/DronecodeSDK-Swift \
    --github-file-prefix https://github.com/Dronecode/DronecodeSDK-Swift/tree/master \
    --module-version master \
    --xcodebuild-arguments -project,Dronecode-SDK-Swift.xcodeproj,-scheme,Dronecode_SDK_Swift \
    --module Dronecode-SDK-Swift \
    --root-url https://sdk.dronecode.org/docs/swift \
    --output docs/swift_output \
    --module Dronecode_SDK_Swift
