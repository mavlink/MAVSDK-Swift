#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${SCRIPT_DIR}/init_variables.bash

curl https://s3.eu-central-1.amazonaws.com/dronecode-sdk/${ARCHIVE_SDK_CURRENT} --output ${TMP_DIR}/${ARCHIVE_SDK_CURRENT}
unzip -o ${TMP_DIR}/${ARCHIVE_SDK_CURRENT} -d ${BIN_DIR}
