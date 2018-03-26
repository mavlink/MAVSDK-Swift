#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${SCRIPT_DIR}/init_variables.bash

aws s3 cp ${BIN_DIR}/${ARCHIVE_DEPS} s3://dronecode-sdk/${ARCHIVE_DEPS}
aws s3api put-object-acl --bucket dronecode-sdk --key ${ARCHIVE_DEPS} --acl public-read

aws s3 cp ${BIN_DIR}/${ARCHIVE_SDK} s3://dronecode-sdk/${ARCHIVE_SDK}
aws s3api put-object-acl --bucket dronecode-sdk --key ${ARCHIVE_SDK} --acl public-read
