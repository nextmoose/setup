#!/bin/sh

sh $(dirname ${0})/destroy-pass-gpg-tar.sh &&
    sh $(dirname ${0})/create-pass-gpg-tar.sh &&
    sh $(dirname ${0})/create-install-src.sh &&
    cd build/src &&
    nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
