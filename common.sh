#!/usr/bin/env bash

set -Eeuo pipefail
trap "echo ERR trap fired!" ERR

OCAML_VERSION=$1
OCAML="ocaml-$OCAML_VERSION"
MANIFEST="$OCAML/package.json"

PLATFORM=''

case "$OSTYPE" in
  linux*)   PLATFORM='linux' ;;
  darwin*)  PLATFORM='darwin' ;;
  *)        echo "unknown: $OSTYPE"; exit 1 ;;
esac


