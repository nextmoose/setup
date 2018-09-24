#!/bin/sh

DIR=$(mktemp -d) &&
    sudo mount /dev/sdb1 ${DIR} &&
    cd ${DIR}/nixos/public &&
    git fetch origin nixos-5 &&
    git checkout -b scratch/$(uuidgen) &&
    git commit -am "wtf" --allow-empty &&
    git diff origin/nixos-5 &&
    git checkout origin/nixos-5 &&
    git log -n 1
