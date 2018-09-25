#!/bin/sh

WORK_DIR=$(mktemp -d) &&
    cleanup() {
	echo ${WORK_DIR}
    } &&
    trap cleanup EXIT &&
    mkdir ${WORK_DIR}/.ssh &&
    ssh-keygen -f ${WORK_DIR}/.ssh/id_rsa -P "" -C "" &&
    sed \
	-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ${WORK_DIR}/.ssh/id_rsa)#" \
	-e "w${WORK_DIR}/iso.nix" \
	iso.nix.template &&
    mkdir ${WORK_DIR}/installer &&
    cp installer.nix ${WORK_DIR}/installer/default.nix &&
    mkdir ${WORK_DIR}/installer/src &&
    cp installer.sh ${WORK_DIR}/installer/src/installer.sh &&
    sed \
	-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ${WORK_DIR}/.ssh/id_rsa)#" \
	-e "s#HASHED_PASSWORD#$(echo password | mkpasswd -m sha-512 --stdin)#" \
	-e "w${WORK_DIR}/installer/src/configuration.nix" \
	configuration.nix.template &&
    cp -r custom ${WORK_DIR}/installer/src/custom &&
    (
	cd ${WORK_DIR}
	time nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
    ) &&
    true
