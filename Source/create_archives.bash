#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${SCRIPT_DIR}/init_variables.bash

if [ -f ${BIN_DIR}/${ARCHIVE_DEPS} ]; then
    mv ${BIN_DIR}/${ARCHIVE_DEPS} ${TMP_DIR}
fi

if [ -f ${BIN_DIR}/${ARCHIVE_SDK} ]; then
    mv ${BIN_DIR}/${ARCHIVE_SDK} ${TMP_DIR}
fi

for REQUIRED_FRAMEWORK in BoringSSL CgRPC Czlib Dronecode_SDK_Swift RxSwift RxTest RxBlocking SwiftProtobuf SwiftProtobufPluginLibrary backend gRPC; do
    if [ ! -d ${BIN_DIR}/${REQUIRED_FRAMEWORK}.framework ]; then
        echo "Error: ${REQUIRED_FRAMEWORK}.framework is missing in ${BIN_DIR}!"
        exit 1
    fi
done

cd ${BIN_DIR}
zip -9 -r ${BIN_DIR}/${ARCHIVE_DEPS} *.framework -x '*Dronecode_SDK_Swift.framework*'
zip -9 -r ${BIN_DIR}/${ARCHIVE_SDK} *.framework 

echo "Archives created. Old files may have been move to: ${TMP_DIR}"
