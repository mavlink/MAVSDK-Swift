#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${SCRIPT_DIR}/init_variables.bash

if [ -f ${BIN_DIR}/${ARCHIVE_DEPS_LATEST} ]; then
    mv ${BIN_DIR}/${ARCHIVE_DEPS_LATEST} ${TMP_DIR}
fi

if [ -f ${BIN_DIR}/${ARCHIVE_DEPS_CURRENT} ]; then
    mv ${BIN_DIR}/${ARCHIVE_DEPS_CURRENT} ${TMP_DIR}
fi

if [ -f ${BIN_DIR}/${ARCHIVE_SDK_LATEST} ]; then
    mv ${BIN_DIR}/${ARCHIVE_SDK_LATEST} ${TMP_DIR}
fi

if [ -f ${BIN_DIR}/${ARCHIVE_SDK_CURRENT} ]; then
    mv ${BIN_DIR}/${ARCHIVE_SDK_CURRENT} ${TMP_DIR}
fi

for REQUIRED_FRAMEWORK in Dronecode_SDK_Swift backend; do
    if [ ! -d ${BIN_DIR}/${REQUIRED_FRAMEWORK}.framework ]; then
        echo "Error: ${REQUIRED_FRAMEWORK}.framework is missing in ${BIN_DIR}!"
        exit 1
    fi
done

cd ${BIN_DIR}
zip -9 -r ${BIN_DIR}/${ARCHIVE_DEPS_LATEST} *.framework -x '*Dronecode_SDK_Swift.framework*'
zip -9 -r ${BIN_DIR}/${ARCHIVE_SDK_LATEST} *.framework 

cp ${BIN_DIR}/${ARCHIVE_DEPS_LATEST} ${BIN_DIR}/${ARCHIVE_DEPS_CURRENT}
cp ${BIN_DIR}/${ARCHIVE_SDK_LATEST} ${BIN_DIR}/${ARCHIVE_SDK_CURRENT}

echo "Archives created. Old files may have been move to: ${TMP_DIR}"
