#!/usr/bin/env bash

set -euo pipefail

SBOM_PATH="${RUGIX_ARTIFACTS_DIR}/${RECIPE_PARAM_SBOM_FILE}"
SBOM_DIR=$(dirname "${SBOM_PATH}")

if [ ! -d "${SBOM_DIR}" ]; then
    mkdir -p "${SBOM_DIR}"
fi

dpkg --list > "${SBOM_PATH}"