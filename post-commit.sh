#!/bin/sh

[ $(id -u) == 1000 ] &&
    sudo rm /etc/nixos/*.nix &&
    sudo cp *.nix /etc/nixos/ &&
    sudo nixos-rebuild switch
