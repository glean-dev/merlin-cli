#!/usr/bin/env bash

set -Eeuo pipefail
trap "echo ERR trap fired!" ERR

source common.sh

esy @$OCAML install --cache-tarballs-path=./$OCAML._esyinstall
esy @$OCAML build
esy @$OCAML release

mkdir $OCAML
ls _release/_export/*.tar.gz | xargs -i tar xzf {} -C $OCAML --strip-components=1
rm -rf _release

cp package.json $MANIFEST
if [ "$PLATFORM" == "darwin" ]; then
  sed -i '' "s/%%OCAML_VERSION%%/$OCAML_VERSION/g" $MANIFEST
  sed -i '' "s/%%PLATFORM%%/$PLATFORM/g" $MANIFEST
else
  sed -i "s/%%OCAML_VERSION%%/$OCAML_VERSION/g" $MANIFEST
  sed -i "s/%%PLATFORM%%/$PLATFORM/g" $MANIFEST
fi

cd $OCAML && npm pack && mv *.tgz ..
