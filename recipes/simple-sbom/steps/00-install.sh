#!/usr/bin/env bash

set -euo pipefail

SBOM_PATH="${RUGPI_PROJECT_DIR}/${RUGPI_PARAM_SBOM_FILE}"
SBOM_DIR=$(dirname "${SBOM_PATH}")

if [ -d "${SBOM_DIR}" ]; then
    mkdir -p "${SBOM_DIR}"
fi

dpkg --list > "${RUGPI_PROJECT_DIR}/${RUGPI_PARAM_SBOM_FILE}"