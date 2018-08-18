#!/bin/sh

read -p "USER PASSWORD?" USER_PASSWORD &&
    sh ../private/wifi.sh &&
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
    mkfs.vfat -F 32 -n BOOT /dev/sda1 &&
    mkswap -L SWAP /dev/sda2 &&
    echo y | mkfs.ext4 -L ROOT /dev/sda3 &&
    KEY_FILE=$(mktemp) &&
    echo "${USER_PASSWORD}" > ${KEY_FILE} &&
    cryptsetup --key-file ${KEY_FILE} luksFormat /dev/sda4 &&
    cryptsetup --key-file ${KEY_FILE} luksOpen /dev/sda4 keys &&
    # mkfs.ext4 /dev/keys &&
    pvcreate --force /dev/sda5 &&
    vgcreate volumes /dev/sda5 &&
    mount /dev/sda3 /mnt &&
    mkdir /mnt/boot &&
    mount /dev/sda1 /mnt/boot/ &&
    # mkdir /mnt/keys &&
    # mount /dev/keys /mnt/keys/ &&
    swapon -L SWAP &&
    nixos-generate-config --root /mnt &&
    cat configuration.nix > /mnt/etc/nixos/configuration.nix &&
    ROOT_PASSWORD=$(uuidgen) &&
    (cat <<EOF
${ROOT_PASSWORD}
${ROOT_PASSWORD}
EOF
    ) | nixos-install &&
    PRIVATE_VOLUME=24fd963r &&
    lvcreate --size 1G --name ${PRIVATE_VOLUME} volumes &&
    mkfs.ext4 -F /dev/volumes/${PRIVATE_VOLUME} &&
    DIR=$(mktemp -d) &&
    mount /dev/volumes/${PRIVATE_VOLUME} ${DIR} &&
    cat ../private/wifi.sh > ${DIR}/wifi.sh &&
    chmod 0500 ${DIR}/wifi.sh &&
    chown 1000:100 ${DIR}/wifi.sh &&
    mkdir /mnt/home/user/bin &&
    ls -1 bin | while read FILE
    do
	cat bin/${FILE} > /mnt/home/user/bin/${FILE%.*} &&
	    chmod 0500 /mnt/home/user/bin/${FILE%.*} &&
	    chown 1000:100 /mnt/home/user/bin/${FILE%.*}
    done &&
    chown 1000:100 /mnt/home/user/bin &&
    echo user:${USER_PASSWORD} | chpasswd --root /mnt &&
    shutdown -h now
