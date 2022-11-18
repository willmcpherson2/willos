#!/usr/bin/env bash

set -euxo pipefail

ssh-keygen -t ed25519 -C "willmcpherson2@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub | wl-copy
