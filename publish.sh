#!/usr/bin/env bash

set -Eeuo pipefail
trap "echo ERR trap fired!" ERR

source common.sh

cd $OCAML
echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > .npmrc
npm publish --access public --tag "latest-$PLATFORM"
