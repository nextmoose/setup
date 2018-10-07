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
    if [ ! -d build ]
    then
	mkdir build
    fi &&
    if [ ! -d build/virtual ]
    then
	mkdir build/virtual
    fi &&
    cp src/common/iso.nix build/virtual &&
    sed \
	-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ${HOME}/.ssh/origin.id_rsa)#" \
	-e "wbuild/virtual/iso.isolated.nix" \
	src/virtual/iso.isolated.nix.template &&
    if [ ! -d build/virtual/installer ]
    then
	mkdir build/virtual/installer
    fi &&
    cp src/common/installer.nix build/virtual/installer/default.nix &&
    if [ ! -d build/virtual/installer/src ]
    then
	mkdir build/virtual/installer/src
    fi &&
    cp src/common/installer.sh.template build/virtual/installer/src &&
    cp src/common/configuration.nix build/virtual/installer/src &&
    sed \
	-e "s#HASHED_PASSWORD#$(uuidgen | mkpasswd -m sha-512 --stdin)#" \
	-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ~/.ssh/origin.id_rsa)#" \
	-e "wbuild/virtual/installer/src/configuration.isolated.nix" \
	src/virtual/configuration.isolated.nix.template &&
    cp --recursive src/common/custom build/virtual/installer/src/custom &&
    mkdir ${TEMP_DIR}/secrets &&
    ls -1 /secrets | while read FILE
    do
	[ 700 != $(stat --printf %a /secrets/${FILE}) ] &&
	    cp /secrets/${FILE} ${TEMP_DIR}/secrets/${FILE}
    done &&
    tar --create --file ${TEMP_DIR}/secrets.tar --directory ${TEMP_DIR}/secrets . &&
    rm --recursive --force ${TEMP_DIR}/secrets &&
    rm --force build/virtual/installer/src/secrets.tar.gpg &&
    echo "${SYMMETRIC_PASSPHRASE}" | gpg --batch --passphrase-fd 0 --output build/virtual/installer/src/secrets.tar.gpg --symmetric ${TEMP_DIR}/secrets.tar &&
    rm -rf ${TEMP_DIR}/secrets.tar &&
    (
	cd build/virtual &&
	    time nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
    ) &&
    true
