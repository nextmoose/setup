#!/bin/sh

while [ ${#} -gt 0 ]
do
    case "${1}" in
	*)
	    echo Unknown Option &&
		echo ${0} &&
		echo ${@} &&
		exit 64
	    ;;
    esac
done &&
    mkfs.vfat -F 32 -n BOOT /dev/sda1 &&
    mkswap -L SWAP /dev/sda2 &&
    echo y | mkfs.ext4 -L ROOT /dev/sda3 &&
    mount /dev/sda3 /mnt &&
    mkdir /mnt/boot &&
    mount /dev/sda1 /mnt/boot/ &&
    swapon -L SWAP &&
    nixos-generate-config --root /mnt &&
    cat configuration.nix > /mnt/etc/nixos/configuration.nix &&
    nixos-install &&
    mkdir /mnt/home/user/bin &&
    chown 1000:1000 /mnt/home/user/bin &&
    chmod 0700 /mnt/home/user/bin &&
    cp install.user.sh /mnt/home/user/bin/install.sh &&
    chown 1000:1000 /mnt/home/user/bin/install.sh &&
    chmod 0500 /mnt/home/user/bin/install.sh &&
    shutdown -h now
