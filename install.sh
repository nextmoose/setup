#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	--user-password)
	    export USER_PASSWORD="${2}" &&
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



8E00
w
Y
EOF
    ) | gdisk /dev/sda &&
    mkfs.vfat -F 32 -n BOOT /dev/sda1 &&
    mkswap -L SWAP /dev/sda2 &&
    echo y | mkfs.ext4 -L ROOT /dev/sda3 &&
    pvcreate --force /dev/sda4 &&
    vgcreate volumes /dev/sda4 &&
    mount /dev/sda3 /mnt &&
    mkdir /mnt/boot &&
    mount /dev/sda1 /mnt/boot/ &&
    swapon -L SWAP &&
    nixos-generate-config --root /mnt &&
    sh ./run.sh --source configuration --destination /mnt/etc/nixos --user-password "${USER_PASSWORD}" &&
    ROOT_PASSWORD=$(uuidgen) &&
    (cat <<EOF
${ROOT_PASSWORD}
${ROOT_PASSWORD}
EOF
    ) | nixos-install &&
    PRIVATE_VOLUME=24fd963r &&
    lvcreate --size 1G --name ${PRIVATE_VOLUME} volumes &&
    mkfs.ext4 /dev/volumes/${PRIVATE_VOLUME} &&
    DIR=$(mktemp -d) &&
    mount /dev/volumes/${PRIVATE_VOLUME} ${DIR} &&
    cat ../private/wifi.sh > ${DIR}/wifi.sh &&
    chmod 0500 ${DIR}/wifi.sh &&
    chown 1000:100 ${DIR}/wifi.sh &&
    cat ../private/gpg.secret.key > ${DIR}/gpg.secret.key &&
    chmod 0500 ${DIR}/gpg.secret.key &&
    chown 1000:100 ${DIR}/gpg.secret.key &&
    cat ../private/gpg.owner.trust > ${DIR}/gpg.owner.trust &&
    chmod 0500 ${DIR}/gpg.owner.trust &&
    chown 1000:100 ${DIR}/gpg.owner.trust &&
    cat ../private/gpg2.secret.key > ${DIR}/gpg2.secret.key &&
    chmod 0500 ${DIR}/gpg2.secret.key &&
    chown 1000:100 ${DIR}/gpg2.secret.key &&
    cat ../private/gpg2.owner.trust > ${DIR}/gpg2.owner.trust &&
    chmod 0500 ${DIR}/gpg2.owner.trust &&
    chown 1000:100 ${DIR}/gpg2.owner.trust &&
    touch /mnt/home/user/.${PRIVATE_VOLUME} &&
    chown 1000:100 /mnt/home/user/.${PRIVATE_VOLUME} &&
    mkdir /mnt/home/user/bin &&
    ls -1 bin | while read FILE
    do
	cat bin/${FILE} > /mnt/home/user/bin/${FILE%.*} &&
	    chmod 0500 /mnt/home/user/bin/${FILE%.*} &&
	    chown 1000:100 /mnt/home/user/bin/${FILE%.*}
    done &&
    chown 1000:100 /mnt/home/user/bin &&
    mkdir /mnt/home/user/completion &&
    ls -1 completion | while read FILE
    do
	cat completion/${FILE} > /mnt/home/user/completion/${FILE%.*} &&
	    chmod 0400 /mnt/home/user/completion/${FILE%.*} &&
	    chown 1000:100 /mnt/home/user/completion/${FILE%.*}
    done &&
    shutdown -h now &&
    true
