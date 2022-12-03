#!/usr/bin/env bash

set -euxo pipefail

pushd /etc/nixos
git init
git remote add origin git@github.com:willmcpherson2/willos.git
git clean -df
git pull --set-upstream origin main
chown -R will .
popd
