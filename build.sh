#!/bin/bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

NODE=deps/node-$(node -p 'process.version')/include/node

if [ ! -d "$NODE" ] ;then
./download-node-headers.sh
fi

clear

zig build-lib \
-lc \
--strip \
-dynamic \
-OReleaseSafe \
-femit-bin=lib.node \
-fallow-shlib-undefined \
-isystem $NODE \
./src/main.zig $@

# -flto \ # -flto is not supported on macos
