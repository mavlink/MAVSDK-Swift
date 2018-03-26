#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${BUILD_DIR:-${SCRIPT_DIR}/build}"
BIN_DIR="${BIN_DIR:-${SCRIPT_DIR}/bin}"

mkdir -p ${BUILD_DIR}
mkdir -p ${BIN_DIR}
cd ${BUILD_DIR}

if [ ! -d rxswift ]; then
    git clone https://github.com/reactivex/rxswift.git
fi

cd rxswift

xcodebuild -target RxSwift-iOS -configuration Release -sdk iphoneos
xcodebuild -target RxSwift-iOS -configuration Release -sdk iphonesimulator

# Generate fat binary
cd build

echo "Generating fat binary for RxSwift"
cp -r Release-iphoneos/RxSwift.framework ${BIN_DIR}

lipo Release-iphoneos/RxSwift.framework/RxSwift Release-iphonesimulator/RxSwift.framework/RxSwift -create -output ${BIN_DIR}/RxSwift.framework/RxSwift

cp Release-iphonesimulator/RxSwift.framework/Modules/RxSwift.swiftmodule/* ${BIN_DIR}/RxSwift.framework/Modules/RxSwift.swiftmodule/

