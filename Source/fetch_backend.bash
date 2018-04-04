#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${SCRIPT_DIR}/init_variables.bash

curl https://s3.eu-central-1.amazonaws.com/dronecode-sdk/${ARCHIVE_BACKEND} --output ${TMP_DIR}/${ARCHIVE_BACKEND}
unzip "${TMP_DIR}/${ARCHIVE_BACKEND}" -d ${BIN_DIR}
