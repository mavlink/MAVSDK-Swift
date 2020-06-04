#!/usr/bin/env bash

set -e

command -v protoc || { echo >&2 "Protobuf needs to be installed (e.g. '$ brew install protobuf') for this script to run!"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PB_PLUGINS_DIR=${PB_PLUGINS_DIR:-"${SCRIPT_DIR}/../proto/pb_plugins"}
PROTO_DIR=${PROTO_DIR:-"${SCRIPT_DIR}/../proto/protos"}
OUTPUT_DIR=${OUTPUT_DIR:-"${SCRIPT_DIR}/../Sources/MAVSDK-Swift/Generated"}

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

    git -C ${TMP_DIR} clone https://github.com/grpc/grpc-swift -b 0.11.0
fi

cd ${TMP_DIR}/grpc-swift && make

for plugin in ${PLUGIN_LIST}; do
    protoc ${plugin}.proto -I${PROTO_DIR} -I${PROTO_DIR}/${plugin} --swift_out=${OUTPUT_DIR} --swiftgrpc_out=${OUTPUT_DIR} --swiftgrpc_opt=TestStubs=true --plugin=protoc-gen-swift=${TMP_DIR}/grpc-swift/protoc-gen-swift --plugin=protoc-gen-swiftgrpc=${TMP_DIR}/grpc-swift/protoc-gen-swiftgrpc
done

echo ""
echo "-------------------------------"
echo "Generating the SDK wrappers"
echo "-------------------------------"
echo ""

if [ ! -d ${PB_PLUGINS_DIR}/venv ]; then
    python3 -m venv ${PB_PLUGINS_DIR}/venv

    source ${PB_PLUGINS_DIR}/venv/bin/activate
    pip install -r ${PB_PLUGINS_DIR}/requirements.txt
    pip install -e ${PB_PLUGINS_DIR}
fi

source ${PB_PLUGINS_DIR}/venv/bin/activate
export TEMPLATE_PATH=${TEMPLATE_PATH:-"${SCRIPT_DIR}/../templates"}

for plugin in ${PLUGIN_LIST}; do
    protoc ${plugin}.proto --plugin=protoc-gen-custom=$(which protoc-gen-dcsdk) -I${PROTO_DIR}  -I${PROTO_DIR}/${plugin} --custom_out=${OUTPUT_DIR} --custom_opt=file_ext=swift
done
