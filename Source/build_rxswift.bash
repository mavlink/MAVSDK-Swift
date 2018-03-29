#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${SCRIPT_DIR}/init_variables.bash

if [ ! -d ${BUILD_DIR}/rxswift ]; then
    git -C ${BUILD_DIR} clone https://github.com/reactivex/rxswift.git
    git -C ${BUILD_DIR}/rxswift checkout 4431b623751ac5525e8a8c2d6e82f29b983af07c
fi

cd ${BUILD_DIR}/rxswift

xcodebuild -target RxSwift-iOS -target RxTest-iOS -target RxBlocking-iOS -configuration Release -sdk iphoneos
xcodebuild -target RxSwift-iOS -target RxTest-iOS -target RxBlocking-iOS -configuration Release -sdk iphonesimulator

# Generate fat binaries
for TARGET in RxSwift RxTest RxBlocking; do
    echo "Generating fat binary for ${TARGET}"
    cp -r ${BUILD_DIR}/rxswift/build/Release-iphoneos/${TARGET}.framework ${BIN_DIR}
    
    lipo ${BUILD_DIR}/rxswift/build/Release-iphoneos/${TARGET}.framework/${TARGET} ${BUILD_DIR}/rxswift/build/Release-iphonesimulator/${TARGET}.framework/${TARGET} -create -output ${BIN_DIR}/${TARGET}.framework/${TARGET}
    
    cp ${BUILD_DIR}/rxswift/build/Release-iphonesimulator/${TARGET}.framework/Modules/${TARGET}.swiftmodule/* ${BIN_DIR}/${TARGET}.framework/Modules/${TARGET}.swiftmodule/
done
