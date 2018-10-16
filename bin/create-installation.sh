#!/bin/sh

sh $(dirname ${0})/create-secrets.sh &&
    sh $(dirname ${0})/create-configuration.sh &&
    mkdir build/installation &&
    cp --recursive build/configuration/. build/installation &&
    cp build/root.tar.gpg build/installation/custom/installer/src &&
    cd build/installation &&
    nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
    true
