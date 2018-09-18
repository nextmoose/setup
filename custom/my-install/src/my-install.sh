#!/bin/sh

(swapoff -L SWAP || true ) &&
    (umount /mnt/secrets || true) &&
    (umount /mnt/boot || true) &&
    (umount /mnt || true) &&
    lvs --options NAME volumes | tail -n -1 | while read NAME
    do
	wipefs --all /dev/volumes/${NAME} &&
	    (lvremove --force /dev/volumes/${NAME} || true)
    done &&
    (vgremove --force /dev/volumes || true) &&
    (pvremove --force /dev/volumes || true) &&
    echo p | gdisk /dev/sda | grep "^\s*[0-9]" | sed -e "s#^\s*##" -e "s#\s.*\$##" | while read I
    do
	wipefs --all /dev/sda${I} &&
	    (cat <<EOF
d
${I}
w
y
EOF
	    ) | gdisk /dev/sda
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

n


+1G

n



8E00
w
Y
EOF
    ) | gdisk /dev/sda &&
    fuckit() {
	mkfs.vfat -F 32 -n BOOT /dev/sda1 &&
	    mkswap -L SWAP /dev/sda2 &&
	    echo y | mkfs.ext4 -L ROOT /dev/sda3 &&
	    cryptsetup luksFormat /dev/sda4 &&
	    cryptsetup luksOpen /dev/sda4 secrets &&
	    echo y | mkfs.ext4 -L SECRETS /dev/mapper/secrets &&
	    pvcreate --force /dev/sda5 &&
	    vgcreate volumes /dev/sda5 &&
	    mount /dev/sda3 /mnt &&
	    mkdir /mnt/boot &&
	    mkdir /mnt/secrets &&
	    mount /dev/mapper/secrets /mnt/secrets &&
	    mount /dev/sda1 /mnt/boot/ &&
	    swapon -L SWAP &&
	    nixos-generate-config --root /mnt &&
	    ROOT_PASSWORD=password &&
	    (cat <<EOF
${ROOT_PASSWORD}
${ROOT_PASSWORD}
EOF
	    ) | nixos-install &&
	    true
    ) &&
    shutdown -h now &&
    true
