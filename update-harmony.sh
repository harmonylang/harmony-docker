#!/bin/bash

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
echo "$tmp_dir"

git clone --depth=1 --branch=master https://github.coecis.cornell.edu/rv22/harmony.git "$tmp_dir"
rm -rf "$tmp_dir/.git"

mkdir harmony-master

mv "$tmp_dir/harmony" ./harmony-master
mv "$tmp_dir/modules" ./harmony-master

rm -rf "$tmp_dir"
