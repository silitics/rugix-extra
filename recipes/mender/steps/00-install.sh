#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

ARCH=$(dpkg --print-architecture)

apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://downloads.mender.io/repos/debian/gpg \
    > /etc/apt/trusted.gpg.d/mender.asc

echo "deb [arch=$ARCH] https://downloads.mender.io/repos/debian debian/bullseye/stable main" \
    > /etc/apt/sources.list.d/mender.list

apt-get update

apt-get install -y mender-client mender-connect

install -D -m 644 "${RECIPE_DIR}/files/mender-state.toml" \
    "/etc/rugix/state/mender.toml"

systemctl enable mender-client.service
systemctl enable mender-connect.service

mkdir -p /usr/lib/rugix-mender/bin
install -D -m 755 "${RECIPE_DIR}/files/reboot" \
    -t /usr/lib/rugix-mender/bin

mkdir -p /usr/share/mender/modules/v3
# We keep the old name of the update module such that Mender artifacts work for versions
# before and after the rename. Otherwise, users would have to build two artifacts. We can
# later add a module `rugix-bundle` for installing Rugix update bundles.
install -D -m 755 "${RECIPE_DIR}/files/rugpi-image" \
    -t /usr/share/mender/modules/v3

mkdir -p /etc/systemd/system/mender-client.service.d
install -D -m 644 "${RECIPE_DIR}/files/rugix-reboot-override.conf" \
    -t /etc/systemd/system/mender-client.service.d