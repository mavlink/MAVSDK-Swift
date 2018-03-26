#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${BUILD_DIR:-${SCRIPT_DIR}/build}"
BIN_DIR="${BIN_DIR:-${SCRIPT_DIR}/bin}"

mkdir -p ${BUILD_DIR}
mkdir -p ${BIN_DIR}
cd ${BUILD_DIR}

if [ ! -d grpc-swift ]; then
    git clone https://github.com/KyoheiG3/grpc-swift.git
fi

cd grpc-swift
make

xcodebuild -target BoringSSL -target gRPC -target Czlib -target CgRPC -target SwiftProtobuf -target SwiftProtobufPluginLibrary -configuration Release -sdk iphoneos
xcodebuild -target BoringSSL -target gRPC -target Czlib -target CgRPC -target SwiftProtobuf -target SwiftProtobufPluginLibrary -configuration Release -sdk iphonesimulator

# Generate fat binaries
cd build

for TARGET_NAME in BoringSSL gRPC Czlib CgRPC SwiftProtobuf SwiftProtobufPluginLibrary; do
    echo "Generating fat binary for ${TARGET_NAME}"
    cp -r Release-iphoneos/${TARGET_NAME}.framework ${BIN_DIR}

    lipo Release-iphoneos/${TARGET_NAME}.framework/${TARGET_NAME} Release-iphonesimulator/${TARGET_NAME}.framework/${TARGET_NAME} -create -output ${BIN_DIR}/${TARGET_NAME}.framework/${TARGET_NAME}

    if [ -d Release-iphonesimulator/${TARGET_NAME}.framework/Modules/${TARGET_NAME}.swiftmodule ]; then
        cp Release-iphonesimulator/${TARGET_NAME}.framework/Modules/${TARGET_NAME}.swiftmodule/* ${BIN_DIR}/${TARGET_NAME}.framework/Modules/${TARGET_NAME}.swiftmodule/
    fi
done
