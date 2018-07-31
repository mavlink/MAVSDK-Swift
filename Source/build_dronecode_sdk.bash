#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${SCRIPT_DIR}/init_variables.bash

xcodebuild -project ${SCRIPT_DIR}/Dronecode-SDK-Swift/Dronecode-SDK-Swift.xcodeproj -target Dronecode-SDK-Swift -configuration Release -sdk iphoneos CONFIGURATION_BUILD_DIR=${BUILD_DIR}/dronecode_sdk/Release-iphoneos
xcodebuild -project ${SCRIPT_DIR}/Dronecode-SDK-Swift/Dronecode-SDK-Swift.xcodeproj -target Dronecode-SDK-Swift -configuration Release -sdk iphonesimulator CONFIGURATION_BUILD_DIR=${BUILD_DIR}/dronecode_sdk/Release-iphonesimulator
#xcodebuild -workspace ${SCRIPT_DIR}/Dronecode-SDK-Swift/Dronecode-SDK-Swift.xcworkspace -scheme Dronecode-SDK-Swift -configuration Release -sdk iphoneos CONFIGURATION_BUILD_DIR=${BUILD_DIR}/dronecode_sdk/Release-iphoneos
#xcodebuild -workspace ${SCRIPT_DIR}/Dronecode-SDK-Swift/Dronecode-SDK-Swift.xcworkspace -scheme Dronecode-SDK-Swift -configuration Release -sdk iphonesimulator CONFIGURATION_BUILD_DIR=${BUILD_DIR}/dronecode_sdk/Release-iphonesimulator

# Generate fat binary
echo "Generating fat binary for Dronecode-SDK-Swift"
cp -r ${BUILD_DIR}/dronecode_sdk/Release-iphoneos/Dronecode_SDK_Swift.framework ${BIN_DIR}

lipo ${BUILD_DIR}/dronecode_sdk/Release-iphoneos/Dronecode_SDK_Swift.framework/Dronecode_SDK_Swift ${BUILD_DIR}/dronecode_sdk/Release-iphonesimulator/Dronecode_SDK_Swift.framework/Dronecode_SDK_Swift -create -output ${BIN_DIR}/Dronecode_SDK_Swift.framework/Dronecode_SDK_Swift

cp ${BUILD_DIR}/dronecode_sdk/Release-iphonesimulator/Dronecode_SDK_Swift.framework/Modules/Dronecode_SDK_Swift.swiftmodule/* ${BIN_DIR}/Dronecode_SDK_Swift.framework/Modules/Dronecode_SDK_Swift.swiftmodule/
