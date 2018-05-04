#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${SCRIPT_DIR}/init_variables.bash

if [ ! -d ${BUILD_DIR}/grpc-swift ]; then
    git -C ${BUILD_DIR} clone https://github.com/dronecore/grpc-swift.git
fi

cd ${BUILD_DIR}/grpc-swift
make

xcodebuild -target BoringSSL -target gRPC -target Czlib -target CgRPC -target SwiftProtobuf -target SwiftProtobufPluginLibrary -configuration Release -sdk iphoneos CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
xcodebuild -target BoringSSL -target gRPC -target Czlib -target CgRPC -target SwiftProtobuf -target SwiftProtobufPluginLibrary -configuration Release -sdk iphonesimulator CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO

# Generate fat binaries
for TARGET_NAME in BoringSSL gRPC Czlib CgRPC SwiftProtobuf SwiftProtobufPluginLibrary; do
    echo "Generating fat binary for ${TARGET_NAME}"
    cp -r ${BUILD_DIR}/grpc-swift/build/Release-iphoneos/${TARGET_NAME}.framework ${BIN_DIR}

    lipo ${BUILD_DIR}/grpc-swift/build/Release-iphoneos/${TARGET_NAME}.framework/${TARGET_NAME} ${BUILD_DIR}/grpc-swift/build/Release-iphonesimulator/${TARGET_NAME}.framework/${TARGET_NAME} -create -output ${BIN_DIR}/${TARGET_NAME}.framework/${TARGET_NAME}

    if [ -d ${BUILD_DIR}/grpc-swift/build/Release-iphonesimulator/${TARGET_NAME}.framework/Modules/${TARGET_NAME}.swiftmodule ]; then
        cp ${BUILD_DIR}/grpc-swift/build/Release-iphonesimulator/${TARGET_NAME}.framework/Modules/${TARGET_NAME}.swiftmodule/* ${BIN_DIR}/${TARGET_NAME}.framework/Modules/${TARGET_NAME}.swiftmodule/
    fi
done

sed -i '' 's/module CgRPC/framework module CgRPC/' ${BIN_DIR}/CgRPC.framework/Modules/module.modulemap
