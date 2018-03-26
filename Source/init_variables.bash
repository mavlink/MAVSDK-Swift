#!/bin/bash

set -e

unset SCRIPT_DIR

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BUILD_DIR="${BUILD_DIR:-${SCRIPT_DIR}/build}"
BIN_DIR="${BIN_DIR:-${SCRIPT_DIR}/bin}"

ARCHIVE_BACKEND=dronecode-backend-latest.zip
ARCHIVE_DEPS=dronecode-sdk-swift-deps-latest.zip
ARCHIVE_SDK=dronecode-sdk-swift-latest.zip

mkdir -p ${BUILD_DIR}
mkdir -p ${BIN_DIR}

TMP_DIR="$(mktemp -d)"
echo "Making a temporary directory for this build: ${TMP_DIR}"
