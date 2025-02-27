#!/usr/bin/env bash

set -euo pipefail

if [ ! -e keys/id_rsa ]; then
    ./generate-test-keys.sh
fi

export RUGIX_DEV=true

./run-bakery bake image mender-efi-arm64

if [ ! -e build/mender-artifact ]; then
    wget -O build/mender-artifact \
        https://downloads.mender.io/mender-artifact/4.0.0/darwin/mender-artifact
    
    chmod +x build/mender-artifact
fi

VERSION=$(date +'%Y%m%d.%H%M')
build/mender-artifact write module-image \
    -n "Image ${VERSION}" \
    -t rugix-generic-efi \
    -T rugpi-image \
    -f build/mender-efi-arm64/system.img \
    -o build/mender-efi-arm64/system.mender \
    --software-name "Rugpi Image" \
    --software-version "${VERSION}"

./run-bakery test