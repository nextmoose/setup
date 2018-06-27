#!/bin/sh

source ./private.env &&
    sed \
	-e "s#^\t#nmcli device wifi connect \"#" \
	-e "s#\t\t*#\" password \"#" \
	-e "s#\t\$#\" ||#" \
	-e "w/tmp/wifi.sh" \
	wifi.sh.template &&
    while ! nmcli device wifi rescan
    do
        sleep 1s
    done &&
    sh /tmp/wifi.sh &&
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
    mkdir /mnt/etc/nixos/configuration.d &&
    cp configuration.d/*.nix /mnt/etc/nixos/configuration.d &&
    ROOT_PASSWORD=$(uuidgen) &&
    (cat <<EOF
${ROOT_PASSWORD}
${ROOT_PASSWORD}
EOF
    ) | nixos-install &&
    echo user:${USER_PASSWORD} | chpasswd --root /mnt &&
    cp bashrc.sh /mnt/home/user/.bashrc &&
    chown 1000:1000 /mnt/home/user/.bashrc &&
    chmod 0500 /mnt/home/user/.bashrc &&
    cp /tmp/wifi.sh gpg.secret.key gpg.owner.trust public.env /mnt/home/user/ &&
    chown 1000:1000 /mnt/home/user/{wifi.sh,gpg.secret.key,gpg.owner.trust,public.env} &&
    mkdir /home/user/setup &&
    nix-env --install git &&
    git -C /home/user/setup init &&
    git -C /home/user/setup config user.name ${USER_NAME} &&
    git -C /home/user/setup config user.email ${USER_EMAIL} &&
    git -C /home/user/setup remote add origin https://github.com/nextmoose/setup.git &&
    chown -R 1000:1000 /home/user/setup &&
    shutdown -h now
