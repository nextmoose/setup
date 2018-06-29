#!/bin/sh

source ./private.env &&
    source ./public.env &&
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
    mkdir /home/user &&
    mkdir /home/user/.ssh &&
    ssh-keygen -f /home/user/.ssh/id_rsa - P "" -C "internal key" &&
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
    mkdir /mnt/home/user/setup &&
    nix-env --install git &&
    git -C /mnt/home/user/setup init &&
    git -C /mnt/home/user/setup config user.name ${USER_NAME} &&
    git -C /mnt/home/user/setup config user.email ${USER_EMAIL} &&
    git -C /mnt/home/user/setup remote add origin https://github.com/nextmoose/setup.git &&
    chown -R 1000:1000 /mnt/home/user/setup &&
    mkdir /mnt/home/user/.ssh &&
    chmod 0700 /mnt/home/user/.ssh &&
    cp /home/user/.ssh/id_rsa /mnt/home/user/.ssh/id_rsa &&
    cp config.ssh.txt /mnt/home/user/.ssh/config &&
    chmod 0600 /mnt/home/user/.ssh/id_rsa /mnt/home/user/.ssh/config &&
    chmod --recursive 1000:1000 /mnt/home/.ssh &&
    shutdown -h now
