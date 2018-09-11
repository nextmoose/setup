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
	--gpg-passphrase)
	    GPG_PASSPHRASE="${2}" &&
		shift 2
	    ;;
	*)
	    echo Unsupported Option &&
		echo ${1} &&
		echo ${@} &&
		echo ${0} &&
		exit 64
	    ;;
    esac
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
    elif [ -z "${GPG_PASSPHRASE}" ]
    then
	 echo Unspecified GPG_PASSPHRASE &&
	     exit 68
    fi &&
    clear &&
    read -p "VERIFY USER PASSWORD: " -s USER_PASSWORD2 &&
    if [ "${USER_PASSWORD}" == "${USER_PASSWORD2}" ]
    then
	echo VERIFIED USER PASSWORD &&
    else
	echo Unverified USER_PASSWORD &&
	    exit 69
    fi &&
    read -p "VERIFY GPG PASSPHRASE: " -s GPG_PASSPHRASE2 &&
    if [ "${GPG_PASSPHRASE}" == "${GPG_PASSPHRASE2}" ]
    then
	echo VERIFIED GPG PASSPHRASE
    else
	echo Unverified GPG_PASSPHRASE &&
	    exit 70
    fi &&
    clear &&
    sh ../private/wifi.sh &&
    nix-env --install git &&
    nix-env --install gnupg &&
    echo ${GPG_PASSPHRASE} | gpg --batch --passphrase-fd 0 --import ../private/gpg.secret.key &&
    gpg --import-ownertrust ../private/gpg.owner.trust &&
    echo ${GPG_PASSPHRASE} | gpg2 --batch --passphrase-fd 0 --import ../private/gpg2.secret.key &&
    gpg2 --import-ownertrust ../private/gpg2.owner.trust &&
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
    SECRETS=$(mktemp -d) &&
    git -C ${SECRETS} init &&
    git -C ${SECRETS} remote add origin https://github.com/${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git &&
    git -C ${SECRETS} fetch origin master &&
    git -C ${SECRETS} checkout origin/master &&
    cp ../private/wifi.sh /mnt/secrets &&
    echo ${ROOT_PASSWORD} > /mnt/secrets/root.password &&
    echo ${USER_PASSWORD} > /mnt/secrets/user.password &&
    echo ${GPG_PASSPHRASE} | gpg --batch --passphrase-fd 0 --output /mnt/secrets/gpg.secret.key --decrypt ${SECRETS}/gpg.secret.key.gpg &&
    echo ${GPG_PASSPHRASE} | gpg --batch --passphrase-fd 0 --output /mnt/secrets/gpg.owner.trust --decrypt ${SECRETS}/gpg.owner.trust.gpg &&
    echo ${GPG_PASSPHRASE} | gpg --batch --passphrase-fd 0 --output /mnt/secrets/gpg2.secret.key --decrypt ${SECRETS}/gpg2.secret.key.gpg &&
    echo ${GPG_PASSPHRASE} | gpg --batch --passphrase-fd 0 --output /mnt/secrets/gpg2.owner.trust --decrypt ${SECRETS}/gpg2.owner.trust.gpg &&
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
