#!/bin/bash

set -euo pipefail

GITHUB_REPO="rugix/rugix-admin"

# Determine the Rust target triple based on architecture and libc.
if [ "${RECIPE_PARAM_USE_MUSL}" = "true" ]; then
    case "${RUGIX_ARCH}" in
        "amd64")
            TARGET="x86_64-unknown-linux-musl"
            ;;
        "arm64")
            TARGET="aarch64-unknown-linux-musl"
            ;;
        "armv7")
            TARGET="armv7-unknown-linux-musleabihf"
            ;;
        "armhf")
            TARGET="arm-unknown-linux-musleabihf"
            ;;
        "arm")
            TARGET="arm-unknown-linux-musleabi"
            ;;
        *)
            echo "Unsupported architecture '${RUGIX_ARCH}' (MUSL)."
            exit 1
    esac
else
    case "${RUGIX_ARCH}" in
        "amd64")
            TARGET="x86_64-unknown-linux-gnu"
            ;;
        "arm64")
            TARGET="aarch64-unknown-linux-gnu"
            ;;
        "armv7")
            TARGET="armv7-unknown-linux-gnueabihf"
            ;;
        "armhf")
            TARGET="arm-unknown-linux-gnueabihf"
            ;;
        "arm")
            TARGET="arm-unknown-linux-gnueabi"
            ;;
        *)
            echo "Unsupported architecture '${RUGIX_ARCH}' (GNU)."
            exit 1
    esac
fi

install_from_container() {
    cp "/usr/share/rugix/binaries/${TARGET}/rugix-admin" "${RUGIX_ROOT_DIR}/usr/bin"
}

install_from_release() {
    local version="$1"
    local url="https://github.com/${GITHUB_REPO}/releases/download/${version}/binaries-${TARGET}.tar"
    echo "Downloading ${url}..."
    local tmpdir
    tmpdir=$(mktemp -d)
    curl -fSL -o "${tmpdir}/binaries.tar" "${url}"
    tar -xf "${tmpdir}/binaries.tar" -C "${tmpdir}"
    cp "${tmpdir}/rugix-admin" "${RUGIX_ROOT_DIR}/usr/bin"
    rm -rf "${tmpdir}"
}

resolve_version() {
    local source="$1"
    # If source matches a release line prefix (e.g., "v0.5", "v1"), resolve via GitHub API.
    if echo "${source}" | grep -qE '^v[0-9]+(\.[0-9]+)?$'; then
        echo "Resolving latest release for ${source}..." >&2
        local resolved
        resolved=$(curl -fSs "https://api.github.com/repos/${GITHUB_REPO}/releases?per_page=100" \
            | jq -r --arg prefix "${source}." '
                [.[] | select(.tag_name | startswith($prefix)) | .tag_name | ltrimstr("v")]
                | if any(.[]; contains("-") | not)
                  then map(select(contains("-") | not))
                  else .
                  end
                | sort_by(split("-")[0] | split(".") | map(tonumber))
                | last
                | if . then "v" + . else null end')
        if [ -z "${resolved}" ] || [ "${resolved}" = "null" ]; then
            echo "No release found matching '${source}.*'." >&2
            exit 1
        fi
        echo "Resolved to ${resolved}." >&2
        echo "${resolved}"
    else
        echo "${source}"
    fi
}

if [ "${RECIPE_PARAM_SOURCE}" = "container" ]; then
    install_from_container
else
    VERSION=$(resolve_version "${RECIPE_PARAM_SOURCE}")
    install_from_release "${VERSION}"
fi
