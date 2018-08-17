#!/bin/sh

read -p "USER PASSWORD?" USER_PASSWORD &&
    echo USER_PASSWORD=${USER_PASSWORD} &&
    sleep 30s &&
    sh ../private/wifi.sh &&
    while ! nmcli device wifi rescan
    do
        sleep 1s
    done &&
    (cat <<EOF
d
1
d
2
d
3
w
Y
EOF
    ) | gdisk /dev/sda &&
    (cat <<EOF
n


+200M
EF00
n


+8G
8200
n




w
Y
EOF
    ) | gdisk /dev/sda &&
    mkfs.vfat -F 32 -n BOOT /dev/sda1 &&
    mkswap -L SWAP /dev/sda2 &&
    echo y | mkfs.ext4 -L ROOT /dev/sda3 &&
    mount /dev/sda3 /mnt &&
    mkdir /mnt/boot &&
    mount /dev/sda1 /mnt/boot/ &&
    swapon -L SWAP &&
    nixos-generate-config --root /mnt &&
    cat configuration.nix > /mnt/etc/nixos/configuration.nix &&
    ROOT_PASSWORD=$(uuidgen) &&
    (cat <<EOF
${ROOT_PASSWORD}
${ROOT_PASSWORD}
EOF
    ) | nixos-install &&
    echo user:${USER_PASSWORD} | chpasswd --root /mnt &&
    shutdown -h now
