#!/bin/sh

sh $(dirname ${0})/create-virtual.sh &&
    sudo cp build/virtual/installer/src/configuration.isolated.nix /etc/nixos/configuration.isolated.nix &&
    sudo cp build/virtual/installer/src/configuration.nix /etc/nixos/configuration.nix &&
    sudo cp --recursive build/dot-ssh/config build/virtual/installer/src/custom /etc/nixos/custom &&
    sudo nixos-rebuild switch &&
    true
