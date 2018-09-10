#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	--user-password)
	    USER_PASSWORD="${2}" &&
		shift 2
	    ;;
	--origin-organization)
	    ORIGIN_ORGANIZATION="${2}" &&
		shift 2
	    ;;
	--origin-repository)
	    ORIGIN_REPOSITORY="${2}" &&
		shift 2
	    ;;
	*)
	    echo Unsupported Option &&
		echo ${1} &&
		echo ${@} &&
		echo ${0} &&
		exit 64
	    ;;
    esac &&
done &&
    if [ -z "${USER_PASSWORD}" ]
    then
	echo Unspecified USER_PASSWORD &&
	    exit 65
    elif [ -z "${ORIGIN_ORGANIZATION}" ]
    then
	echo Unspecified ORIGIN_ORGANIZATION &&
	    exit 66
    elif [ -z "${ORIGIN_REPOSITORY}" ]
    then
	echo Unspecified ORIGIN_REPOSITORY &&
	    exit 67
    fi &&
    sh ../private/wifi.sh &&
    nix-env -i mkpasswd &&
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
    echo y | mkfs.ext4 -L SECRETS /dev/sda4 &&
    pvcreate --force /dev/sda5 &&
    vgcreate volumes /dev/sda5 &&
    mount /dev/sda3 /mnt &&
    mkdir /mnt/boot &&
    mkdir /mnt/secrets &&
    mount /dev/sda4 /mnt/secrets &&
    mount /dev/sda1 /mnt/boot/ &&
    swapon -L SWAP &&
    nixos-generate-config --root /mnt &&
    sh ./run.sh --source configuration --destination /mnt/etc/nixos --user-password "${USER_PASSWORD}" &&
    ROOT_PASSWORD=$(uuidgen) &&
    nix-env --install git &&
    nix-env --install pass &&
    nix-env --install gnupg &&
    gpg --import ../private/gpg.secret.key &&
    gpg --import-ownertrust ../private/gpg.owner.trust &&
    gpg2 --import ../private/gpg2.secret.key &&
    gpg2 --import-ownertrust ../private/gpg2.owner.trust &&
    pass init $(gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":") &&
    pass git init &&
    pass git remote add origin https://github.com/${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git &&
    pass git fetch origin master &&
    echo ${ROOT_PASSWORD} > /mnt/secrets/root.password &&
    pass gpg.secret.key > /mnt/secrets/gpg.secret.key &&
    pass gpg.owner.trust > /mnt/secrets/gpg.owner.trust &&
    pass gpg2.secret.key > /mnt/secrets/gpg2.secret.key &&
    pass gpg2.owner.trust > /mnt/secrets/gpg2.owner.trust &&
    chown -R 1000:100 /mnt/secrets &&
    (cat <<EOF
${ROOT_PASSWORD}
${ROOT_PASSWORD}
EOF
    ) | nixos-install &&
    touch /mnt/home/user/.flag &&
    chown 1000:100 /mnt/home/user/.flag &&
    shutdown -h now &&
    true
