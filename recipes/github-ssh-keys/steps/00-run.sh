#!/bin/bash
# spell:ignore github

set -euo pipefail

mkdir -p /root/.ssh

for gh_user in ${RECIPE_PARAM_GITHUB_USERS}; do
    echo "adding SSH keys of user $gh_user"
    ssh_keys=$(curl -fsSL "https://github.com/${gh_user}.keys" ||:)
    if [ -n "$ssh_keys" ]; then
        echo "# GitHub User: ${gh_user}" >> /root/.ssh/authorized_keys
        echo "$ssh_keys" >> /root/.ssh/authorized_keys
    fi
done

chmod -R 600 /root/.ssh
cat /root/.ssh/authorized_keys