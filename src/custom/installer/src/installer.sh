#!/bin/sh

export PATH=${PATH}:GNUPG &&
    TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${TEMP_DIR}
    } &&
    trap cleanup EXIT &&
    SHUTDOWN="true" &&
    VOLUMES="true" &&
    while [ ${#} -gt 0 ]
    do
	case ${1} in
	    --no-shutdown)
		SHUTDOWN="false" &&
		    shift
		;;
	    --no-volumes)
		VOLUMES="false" &&
		    shift
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
    read -s -p "SYMMETRIC_PASSPHRASE? " SYMMETRIC_PASSPHRASE &&
    export PATH=${PATH}:PKGS.GNUPG &&
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


+20G

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
    echo "${SYMMETRIC_PASSPHRASE}" | gpg --batch --passphrase-fd 0 --output ${TEMP_DIR}/pass.tar OUT/etc/pass.tar.gpg &&
    mkdir ${TEMP_DIR}/pass &&
    tar --extract --file ${TEMP_DIR}/pass.tar --directory ${TEMP_DIR}/pass &&
    source ${TEMP_DIR}/pass/installer.env &&
    echo -n "${LUKS_PASSPHRASE}" | cryptsetup --key-file - luksFormat /dev/sda3 &&
    echo -n "${LUKS_PASSPHRASE}" | cryptsetup --key-file - luksOpen /dev/sda3 nix &&
    echo y | mkfs.ext4 -L NIX /dev/mapper/nix &&
    echo y | mkfs.ext4 -L ROOT /dev/sda4 &&
    mount /dev/sda4 /mnt &&
    mkdir /mnt/boot &&
    mkdir /mnt/nix &&
    mount /dev/sda1 /mnt/boot/ &&
    mount /dev/mapper/nix /mnt/nix &&
    swapon -L SWAP &&
    nixos-generate-config --root /mnt &&
    cp OUT/etc/configuration.nix /mnt/etc/nixos &&
    cp --recursive OUT/etc/custom /mnt/etc/nixos &&
    cp --recursive ${TEMP_DIR}/pass/secrets /mnt/etc/nixos/custom/pass/src &&
    (cat > /mnt/etc/nixos/password.nix <<EOF
{ config, pkgs, ... }:
{
  users.extraUsers.user.hashedPassword = "$(echo ${USER_PASSWORD} | mkpasswd --stdin -m sha-512)"
}
EOF
    ) &&
    nixos-install &&
    if [ "${SHUTDOWN}" == true ]
    then
	shutdown -h now
    fi &&
    true
