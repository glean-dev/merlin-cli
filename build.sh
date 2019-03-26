#!/usr/bin/env bash

declare -a versions=("ocaml-4.02.3" "ocaml-4.07.1")

for OCAML in "${versions[@]}"
do
  esy @$OCAML install --cache-tarballs-path=./$OCAML._esyinstall
  esy @$OCAML build
  esy @$OCAML release
  mkdir $OCAML
  ls _release/_export/*.tar.gz | xargs -i tar xzf {} -C $OCAML --strip-components=1
  rm -rf _release
done
