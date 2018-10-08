#!/bin/sh

sh $(dirname ${0})/create-install-src.sh &&
    cd build/src &&
    time nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
