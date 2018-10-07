#!/bin/sh


TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${TEMP_DIR}
    } &&
    trap cleanup EXIT &&
    while [ -z "${SYMMETRIC_PASSPHRASE}" ]
    do
	read -s -p "Symmetric Passphrase? " SYMMETRIC_PASSPHRASE &&
	    read -s -p "Verify Symmetric Passphrase? " VERIFY_SYMMETRIC_PASSPHRASE &&
	    if [ "${SYMMETRIC_PASSPHRASE}" == "${VERIFY_SYMMETRIC_PASSPHRASE}" ]
	    then
		echo Verified Symmetric Passphrase
	    else
		echo Failed to Verify Symmetric Passphrase &&
		    exit 65
	    fi
    done &&
    while [ -z "${USER_PASSWORD}" ]
    do
	read -s -p "User Passphrase? " USER_PASSWORD &&
	    read -s -p "Verify Symmetric Password? " VERIFY_USER_PASSWORD &&
	    if [ "${USER_PASSWORD}" == "${VERIFY_USER_PASSWORD}" ]
	    then
		echo Verified User Password
	    else
		echo Failed to Verify User Password &&
		    exit 66
	    fi
    done &&
    if [ ! -d build ]
    then
	mkdir build
    fi &&
    if [ ! -d build/real ]
    then
	mkdir build/real
    fi &&
    cp src/common/iso.nix build/real &&
    cp src/real/iso.isolated.nix build/real &&
    if [ ! -d build/real/installer ]
    then
	mkdir build/real/installer
    fi &&
    cp src/common/installer.nix build/real/installer/default.nix &&
    if [ ! -d build/real/installer/src ]
    then
	mkdir build/real/installer/src
    fi &&
    cp src/common/installer.sh.template build/real/installer/src &&
    cp src/common/configuration.nix build/real/installer/src &&
    sed \
	-e "s#HASHED_PASSWORD#$(echo ${CONFIRMED_PASSWORD} | mkpasswd -m sha-512 --stdin)#" \
	-e "wbuild/real/installer/src/configuration.isolated.nix" \
	src/real/configuration.isolated.nix.template &&
    cp -r src/common/custom build/real/installer/src/custom &&
    mkdir ${TEMP_DIR}/secrets &&
    ls -1 /secrets | while read FILE
    do
	[ 700 != $(stat --printf %a /secrets/${FILE}) ] &&
	    cp /secrets/${FILE} ${TEMP_DIR}/secrets/${FILE}
    done &&
    tar --create --file ${TEMP_DIR}/secrets.tar --directory ${TEMP_DIR}/secrets &&
    echo "${SYMMETRIC_PASSPHRASE}" | gpg --batch --passphrase-fd 0 --output build/real/installer/src/secrets.gpg ${TEMP_DIR}/secrets.tar &&
    (
	cd build/real &&
	    time nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
    ) &&
    true
