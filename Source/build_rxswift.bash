#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${SCRIPT_DIR}/init_variables.bash

if [ ! -d ${BUILD_DIR}/rxswift ]; then
    git -C ${BUILD_DIR} clone https://github.com/reactivex/rxswift.git
    git -C ${BUILD_DIR}/rxswift checkout 4431b623751ac5525e8a8c2d6e82f29b983af07c
fi

cd ${BUILD_DIR}/rxswift

xcodebuild -target RxSwift-iOS -configuration Release -sdk iphoneos
xcodebuild -target RxSwift-iOS -configuration Release -sdk iphonesimulator

# Generate fat binary
echo "Generating fat binary for RxSwift"
cp -r ${BUILD_DIR}/rxswift/build/Release-iphoneos/RxSwift.framework ${BIN_DIR}

lipo ${BUILD_DIR}/rxswift/build/Release-iphoneos/RxSwift.framework/RxSwift ${BUILD_DIR}/rxswift/build/Release-iphonesimulator/RxSwift.framework/RxSwift -create -output ${BIN_DIR}/RxSwift.framework/RxSwift

cp ${BUILD_DIR}/rxswift/build/Release-iphonesimulator/RxSwift.framework/Modules/RxSwift.swiftmodule/* ${BIN_DIR}/RxSwift.framework/Modules/RxSwift.swiftmodule/

