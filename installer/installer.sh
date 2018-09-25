#!/bin/sh

(sudo swapoff -L SWAP || true ) &&
    (sudo umount /mnt/secrets || true) &&
    (sudo umount /mnt/boot || true) &&
    (sudo umount /mnt || true) &&
    sudo lvs --options NAME volumes | tail -n -1 | while read NAME
    do
	sudo wipefs --all /dev/volumes/${NAME} &&
	    (sudo lvremove --force /dev/volumes/${NAME} || true)
    done &&
    (sudo vgremove --force /dev/volumes || true) &&
    (sudo pvremove --force /dev/volumes || true) &&
    echo p | sudo gdisk /dev/sda | grep "^\s*[0-9]" | sed -e "s#^\s*##" -e "s#\s.*\$##" | while read I
    do
	sudo wipefs --all /dev/sda${I} &&
	    (cat <<EOF
d
${I}
w
y
EOF
	    ) | sudo gdisk /dev/sda
    done &&
    (cat <<EOF
n


+200M
EF00
n


+8G
8200
n


+64G

w
Y
EOF
    ) | sudo gdisk /dev/sda &&
    sudo mkfs.vfat -F 32 -n BOOT /dev/sda1 &&
    sudo mkswap -L SWAP /dev/sda2 &&
    echo y | sudo mkfs.ext4 -L ROOT /dev/sda3 &&
    sudo mount /dev/sda3 /mnt &&
    sudo mkdir /mnt/boot &&
    sudo mount /dev/sda1 /mnt/boot/ &&
    sudo swapon -L SWAP &&
    sudo nixos-generate-config --root /mnt &&
    ROOT_PASSWORD=password &&
    cat OUT/etc/nixos/configuration.nix | sudo tee /mnt/etc/nixos/configuration.nix &&
    sudo cp -r OUT/etc/nixos/custom /mnt/etc/nixos &&
    (cat <<EOF
${ROOT_PASSWORD}
${ROOT_PASSWORD}
EOF
    ) | sudo nixos-install &&
    shutdown -h now &&
    true
