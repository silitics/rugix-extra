#!/bin/bash

wget -O "${RUGIX_ROOT_DIR}/etc/zsh/zshrc" https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
touch "${RUGIX_ROOT_DIR}/root/.zshrc"
