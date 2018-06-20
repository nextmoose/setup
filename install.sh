#!/bin/sh

mkfs.vfat -F 32 -n BOOT /dev/sda1 &&
    mkswap -L SWAP /dev/sda2 &&
    mkfs.ext4 -L ROOT /dev/sda3 &&
    mount /dev/sda3 /mnt &&
    mkdir /mnt/boot &&
    mount /dev/sda1 /mnt/boot/ &&
    swapon -L SWAP &&
    nixos-generate-config --root /mnt &&
    cat configuration.nix > /mnt/etc/nixos/configuration.nix &&
    nixos-install &&
    shutdown -h now
