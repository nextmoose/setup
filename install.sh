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
    pvcreate --force /dev/sda4 &&
    vgcreate volumes /dev/sda4 &&
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
    PRIVATE_VOLUME=24fd963r &&
    lvcreate --size 1G --name ${PRIVATE_VOLUME} volumes &&
    mkfs.ext4 -F /dev/volumes/${PRIVATE_VOLUME} &&
    DIR=$(mktemp -d) &&
    mount /dev/volumes/${PRIVATE_VOLUME} ${DIR} &&
    cat ../private/wifi.sh > ${DIR}/wifi.sh &&
    chmod 0500 ${DIR}/wifi.sh &&
    chown 1000:100 ${DIR}/wifi.sh &&
    cat ../private/gpg.secret.key > ${DIR}/gpg.secret.key &&
    chmod 0500 ${DIR}/gpg.secret.key &&
    chown 1000:100 ${DIR}/gpg.secret.key &&
    cat ../private/gpg2.secret.key > ${DIR}/gpg2.secret.key &&
    chmod 0500 ${DIR}/gpg2.secret.key &&
    chown 1000:100 ${DIR}/gpg2.secret.key &&
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
