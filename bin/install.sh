#!/bin/sh

USER_PASSWORD=$(read -p "USER PASSWORD: ") &&
    nmcli device wifi rescan &&
    nmcli device wifi connect "Richmond Sq Guest" "guestwifi" &&
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
    echo user:${USER_PASSWORD} | chpasswd --root /mnt user &&
    cp bin/bashrc.sh /mnt/home/user/.bashrc &&
    chown 1000:1000 /mnt/home/user/.bashrc &&
    chmod 0500 /mnt/home/user/.bashrc &&
    cp private/gpg.secret.key gpg.owner.trust public.env /mnt/home/user/ &&
    chown 1000:1000 /mnt/home/user/{gpg.secret.key,gpg.owner.trust,public.env} &&
    shutdown -h now
