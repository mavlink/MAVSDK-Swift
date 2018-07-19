#!/bin/bash

set -e

unset SCRIPT_DIR

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BUILD_DIR="${BUILD_DIR:-${SCRIPT_DIR}/build}"
BIN_DIR="${BIN_DIR:-${SCRIPT_DIR}/bin}"

CURRENT_VERSION_BACKEND=0.0.1
CURRENT_VERSION_SDK=0.1.0

ARCHIVE_BACKEND_CURRENT=dronecode-backend-${CURRENT_VERSION_BACKEND}.zip
ARCHIVE_DEPS_CURRENT=dronecode-sdk-swift-deps-${CURRENT_VERSION_SDK}.zip
ARCHIVE_SDK_CURRENT=dronecode-sdk-swift-${CURRENT_VERSION_SDK}.zip
ARCHIVE_BACKEND_LATEST=dronecode-backend-latest.zip
ARCHIVE_DEPS_LATEST=dronecode-sdk-swift-deps-latest.zip
ARCHIVE_SDK_LATEST=dronecode-sdk-swift-latest.zip

mkdir -p ${BUILD_DIR}
mkdir -p ${BIN_DIR}

TMP_DIR="$(mktemp -d)"
echo "Making a temporary directory for this build: ${TMP_DIR}"
