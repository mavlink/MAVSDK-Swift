#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${SCRIPT_DIR}/init_variables.bash

aws s3 cp ${BIN_DIR}/${ARCHIVE_DEPS_LATEST} s3://dronecode-sdk/${ARCHIVE_DEPS_LATEST}
aws s3api put-object-acl --bucket dronecode-sdk --key ${ARCHIVE_DEPS_LATEST} --acl public-read

aws s3 cp ${BIN_DIR}/${ARCHIVE_SDK_LATEST} s3://dronecode-sdk/${ARCHIVE_SDK_LATEST}
aws s3api put-object-acl --bucket dronecode-sdk --key ${ARCHIVE_SDK_LATEST} --acl public-read

aws s3 cp ${BIN_DIR}/${ARCHIVE_DEPS_CURRENT} s3://dronecode-sdk/${ARCHIVE_DEPS_CURRENT}
aws s3api put-object-acl --bucket dronecode-sdk --key ${ARCHIVE_DEPS_CURRENT} --acl public-read

aws s3 cp ${BIN_DIR}/${ARCHIVE_SDK_CURRENT} s3://dronecode-sdk/${ARCHIVE_SDK_CURRENT}
aws s3api put-object-acl --bucket dronecode-sdk --key ${ARCHIVE_SDK_CURRENT} --acl public-read
