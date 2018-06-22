#!/bin/sh

[ $(id -u) == 1000 ] &&
    sudo cp configuration.nix /etc/nixos/configuration.nix &&
    sudo nixos-rebuild switch
