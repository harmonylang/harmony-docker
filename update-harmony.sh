#!/bin/bash

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
echo "$tmp_dir"

git clone --depth=1 --branch=master git@github.coecis.cornell.edu:rv22/harmony.git "$tmp_dir"
rm -rf "$tmp_dir/.git"

rm -rf harmony-master
mkdir harmony-master

HARMONY_MASTER="$(pwd)/harmony-master"

function install_harmony() {
    cd "$1" || return
    make all
    cp harmony "$2"
    cp harmony.py "$2"
    cp charm.c "$2"
    cp -r modules "$2/modules"
    cp -r code "$2/code"
}

(install_harmony "$tmp_dir" "$HARMONY_MASTER")

rm -rf "$tmp_dir"
cp wrapper.sh harmony-master/wrapper.sh
