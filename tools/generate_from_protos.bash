#!/usr/bin/env bash

set -e

command -v protoc || { echo >&2 "Protobuf needs to be installed (e.g. '$ brew install protobuf') for this script to run!"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROTO_DIR="${SCRIPT_DIR}/../proto"
OUTPUT_DIR="${SCRIPT_DIR}/../Dronecode-SDK-Swift/Generated"

if [ ! -d ${PROTO_DIR} ]; then
    echo "Script is not in the right location! It will look for the proto files in '${PROTO_DIR}', which doesn't exist!"

    exit 1
fi

if [ ! -d ${OUTPUT_DIR} ]; then
    echo "Script is not in the right location! It is made to generate the files in '${OUTPUT_DIR}', which doesn't exist!"

    exit 1
fi

TMP_DIR="$(mktemp -d)"
echo "Making a temporary directory for this build: ${TMP_DIR}"

git -C ${TMP_DIR} clone https://github.com/grpc/grpc-swift
cd ${TMP_DIR}/grpc-swift
make

for plugin in action camera core mission telemetry; do
    protoc ${plugin}.proto -I${PROTO_DIR}/${plugin} --swift_out=${OUTPUT_DIR} --swiftgrpc_out=${OUTPUT_DIR} --swiftgrpc_opt=TestStubs=true --plugin=protoc-gen-swift=${TMP_DIR}/grpc-swift/protoc-gen-swift --plugin=protoc-gen-swiftgrpc=${TMP_DIR}/grpc-swift/protoc-gen-swiftgrpc
done
