#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR=${SCRIPT_DIR}/bin # The built frameworks will be copied here eventually
DRONECORE_DIR=${SCRIPT_DIR}/dronecore
DRONECORE_SWIFT_DIR=${SCRIPT_DIR}/dronecore-swift

command -v go >/dev/null 2>&1 || { echo "ERROR: 'Go' is required (can be installed with 'brew install golang')"; exit 1; }

mkdir -p ${BIN_DIR}
mkdir -p ${DRONECORE_SWIFT_DIR}
mkdir -p ${DRONECORE_DIR}

# Build dronecore backend
git clone -b develop https://github.com/dronecode/dronecodesdk.git ${DRONECORE_DIR}
git -C ${DRONECORE_DIR} submodule update --init --recursive

cd ${DRONECORE_DIR}
make BUILD_BACKEND=YES && make BUILD_BACKEND=YES ios && make BUILD_BACKEND=YES ios_simulator

bash ${DRONECORE_DIR}/backend/tools/package_backend_framework.bash

# Build SDK
git clone https://github.com/dronecore/dronecore-swift.git ${DRONECORE_SWIFT_DIR}

mkdir -p ${DRONECORE_SWIFT_DIR}/Source/bin
cp -r ${DRONECORE_DIR}/build/fat_bin/backend.framework ${DRONECORE_SWIFT_DIR}/Source/bin/backend.framework

bash ${DRONECORE_SWIFT_DIR}/Source/build_grpc.bash
bash ${DRONECORE_SWIFT_DIR}/Source/build_rxswift.bash
bash ${DRONECORE_SWIFT_DIR}/Source/build_dronecode_sdk.bash

# Copy resulting frameworks into ${BIN_DIR}
cp -r ${DRONECORE_SWIFT_DIR}/Source/bin/* ${BIN_DIR}
