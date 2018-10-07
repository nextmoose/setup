#!/bin/sh

sh $(dirname ${0})/create-virtual.sh &&
    scp -F build/dot-ssh/config build/virtual/installer/src/configuration.isolated.nix use:/etc/nixos/configuration.isolated.nix &&
    scp -F build/dot-ssh/config build/virtual/installer/src/configuration.nix use:/etc/nixos/configuration.nix &&
    scp --recursive -F build/dot-ssh/config build/virtual/installer/src/custom use:/etc/nixos/custom &&
    ssh -F build/dot-ssh/config nixos-rebuild switch &&
    sudo VBoxManage controlvm nixos poweroff soft &&
    sh $(dirname ${0})/boot.sh &&
    true
