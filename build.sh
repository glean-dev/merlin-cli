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

esy @$OCAML install --cache-tarballs-path=./$OCAML._esyinstall
esy @$OCAML build
esy @$OCAML release

mkdir $OCAML
ls _release/_export/*.tar.gz | xargs -i tar xzf {} -C $OCAML --strip-components=1
rm -rf _release

cp package.json $MANIFEST
sed -i "s/%%OCAML_VERSION%%/$OCAML_VERSION/g" $MANIFEST
sed -i "s/%%PLATFORM%%/$PLATFORM/g" $MANIFEST

cd $OCAML && npm pack && mv *.tgz ..
