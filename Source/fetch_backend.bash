#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${SCRIPT_DIR}/init_variables.bash

wget https://s3.eu-central-1.amazonaws.com/dronecode-sdk/${ARCHIVE_BACKEND} -P ${TMP_DIR}
unzip "${TMP_DIR}/${ARCHIVE_BACKEND}" -d ${BIN_DIR}
