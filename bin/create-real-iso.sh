#!/bin/sh

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
    mkdir build/real/installer &&
    cp src/common/installer.nix build/real/installer/default.nix &&
    mkdir build/real/installer/src &&
    cp build/common/installer.sh.template build/real/installer/src &&
    cp build/common/configuration.nix build/real/installer/src &&
    sed \
	-e "s#HASHED_PASSWORD#$(echo ${CONFIRMED_PASSWORD} | mkpasswd -m sha-512 --stdin)#" \
	-e "w${WORK_DIR}/confirmed/installer/src/configuration.isolated.nix" \
	src/real/configuration.isolated.nix.template &&
    cp -r src/common/custom build/real/installer/src/custom &&
    echo "${SYMMETRIC_PASSPHRASE}" | gpg --batch --passphrase-fd 0 --output build/real/confirmed/installer/src/secrets.gpg /secrets &&
    (
	cd build/real &&
	    time nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
    ) &&
    true
