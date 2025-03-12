#!/bin/bash

set -euo pipefail

ENV_FILE="${RUGIX_PROJECT_DIR}/.env"

echo ".env" >> "${LAYER_REBUILD_IF_CHANGED}"

if [ -e "$ENV_FILE" ]; then
    # Inject public SSH key from local environment file.
    . "${RUGIX_PROJECT_DIR}/.env"
    echo "${DEV_SSH_KEYS:-""}" >>"${RUGIX_ROOT_DIR}/root/.ssh/authorized_keys"
fi