#!/bin/bash

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
echo "$tmp_dir"

git clone --depth=1 --branch=master https://github.coecis.cornell.edu/rv22/harmony.git "$tmp_dir"
rm -rf "$tmp_dir/.git"

rm -rf harmony-master
mkdir harmony-master

HARMONY_MASTER="$(pwd)/harmony-master"

function install_harmony() {
    cd "$1" || return
    python3 install.py
    mv modules "$2"
    mv harmony.py "$2"
    mv harmony "$2"
    mv charm.exe "$2"
}

(install_harmony "$tmp_dir" "$HARMONY_MASTER")

rm -rf "$tmp_dir"
cp wrapper.sh harmony-master/wrapper.sh
