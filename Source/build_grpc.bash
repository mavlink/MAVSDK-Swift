#!/bin/bash

set -e

mkdir build
BUILD_DIR=build

cd ${BUILD_DIR}
git clone https://github.com/KyoheiG3/grpc-swift.git
cd grpc-swift
make

xcodebuild -target BoringSSL -target gRPC -target Czlib -target CgRPC -target SwiftProtobuf -target SwiftProtobufPluginLibrary -configuration Release -sdk iphoneos
