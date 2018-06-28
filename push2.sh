#!/bin/sh

[ $(id -u) == 1000 ] &&
    export NIXPKGS=/home/user/nixpkgs &&
    sudo cp configuration.nix /etc/nixos/configuration.nix &&
    sudo cp configuration.d/*.nix /etc/nixos/configuration.d &&
    sudo nixos-rebuild -I nixpkgs=${NIXPKGS} switch
