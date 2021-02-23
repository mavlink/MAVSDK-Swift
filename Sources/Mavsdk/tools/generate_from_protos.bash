#!/usr/bin/env bash

set -e

command -v protoc || { echo >&2 "Protobuf needs to be installed (e.g. '$ brew install protobuf') for this script to run!"; exit 1; }

command -v protoc-gen-mavsdk > /dev/null || {
    echo "------------------------"
    echo "Error"
    echo "------------------------"
    echo >&2 "'protoc-gen-mavsdk' not found in PATH"
    echo >&2 ""
    echo >&2 "You can install it using pip:"
    echo >&2 ""
    echo >&2 "pip3 install protoc-gen-mavsdk"
    exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PB_PLUGINS_DIR=${PB_PLUGINS_DIR:-"${SCRIPT_DIR}/../proto/pb_plugins"}
PROTO_DIR=${PROTO_DIR:-"${SCRIPT_DIR}/../proto/protos"}
OUTPUT_DIR=${OUTPUT_DIR:-"${SCRIPT_DIR}/../Generated"}

PLUGIN_LIST=$(cd ${PROTO_DIR} && ls -d */ | sed 's:/*$::')

if [ ! -d ${PROTO_DIR} ]; then
    echo "Script is not in the right location! It will look for the proto files in '${PROTO_DIR}', which doesn't exist!"

    exit 1
fi

if [ ! -d ${OUTPUT_DIR} ]; then
    echo "Script is not in the right location! It is made to generate the files in '${OUTPUT_DIR}', which doesn't exist!"

    exit 1
fi

echo ""
echo "-------------------------------"
echo "Generating pb and grpc.pb files"
echo "-------------------------------"
echo ""

TMP_DIR=${TMP_DIR:-"$(mktemp -d)"}
echo "Temporary directory for this build: ${TMP_DIR}"

if [ ! -d ${TMP_DIR}/grpc-swift ]; then
    echo ""
    echo "--- Cloning grpc-swift"
    echo ""

    git -C ${TMP_DIR} clone https://github.com/grpc/grpc-swift -b "1.0.0-alpha.20"
fi

make -C ${TMP_DIR}/grpc-swift plugins
PROTOC_GEN_SWIFT=${TMP_DIR}/grpc-swift/.build/release/protoc-gen-swift
PROTOC_GEN_GRPC_SWIFT=${TMP_DIR}/grpc-swift/.build/release/protoc-gen-grpc-swift

for plugin in ${PLUGIN_LIST}; do
    protoc ${plugin}.proto -I${PROTO_DIR} -I${PROTO_DIR}/${plugin} --swift_out=${OUTPUT_DIR} --swiftgrpc_out=${OUTPUT_DIR} --plugin=protoc-gen-swift=${PROTOC_GEN_SWIFT} --plugin=protoc-gen-swiftgrpc=${PROTOC_GEN_GRPC_SWIFT}
done

echo ""
echo "-------------------------------"
echo "Generating the SDK wrappers"
echo "-------------------------------"
echo ""

export TEMPLATE_PATH=${TEMPLATE_PATH:-"${SCRIPT_DIR}/../templates"}

for plugin in ${PLUGIN_LIST}; do
    protoc ${plugin}.proto --plugin=protoc-gen-custom=$(which protoc-gen-mavsdk) -I${PROTO_DIR} -I${PROTO_DIR}/${plugin} --custom_out=${OUTPUT_DIR} --custom_opt=file_ext=swift
done
