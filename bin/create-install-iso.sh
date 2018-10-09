#!/bin/sh

sh $(dirname ${0})/destroy-pass-gpg-tar.sh &&
    sh $(dirname ${0})/create-pass-gpg-tar.sh &&
    sh $(dirname ${0})/create-install-src.sh &&
    cp build/pass.tar.gpg build/src/custom/installer/src &&
    cd build/src &&
    nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix &&
    true
