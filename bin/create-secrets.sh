#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${TEMP_DIR}
    } &&
    trap cleanup EXIT &&
    read -s -p "SYMMETRIC PASSPHRASE? " SYMMETRIC_PASSPHRASE &&
    if [ -z "${SYMMETRIC_PASSPHRASE}" ]
    then
	echo BLANK SYMMETRIC PASSPHRASE &&
	    exit 66
    fi &&
    echo &&
    read -s -p "VERIFY SYMMETRIC PASSPHRASE? " VERIFY_SYMMETRIC_PASSPHRASE &&
    if [ "${SYMMETRIC_PASSPHRASE}" == "${VERIFY_SYMMETRIC_PASSPHRASE}" ]
    then
	echo VERIFIED SYMMETRIC PASSPHRASE
    else
	echo FAILED TO VERIFY SYMMETRIC PASSPHRASE &&
	    exit 67
    fi &&
    echo &&
    echo &&
    read -s -p "LUKS PASSPHRASE? " LUKS_PASSPHRASE &&
    if [ -z "${LUKS_PASSPHRASE}" ]
    then
	echo BLANK LUKS PASSPHRASE &&
	    exit 67
    fi &&
    echo &&
    read -s -p "VERIFY LUKS PASSPHRASE? " VERIFY_LUKS_PASSPHRASE &&
    if [ "${LUKS_PASSPHRASE}" == "${VERIFY_LUKS_PASSPHRASE}" ]
    then
	echo VERIFIED LUKS PASSPHRASE
    else
	echo FAILED TO VERIFY LUKS PASSPHRASE &&
	    exit 68
    fi &&
    echo &&
    echo &&
    read -s -p "USER PASSWORD? " USER_PASSWORD &&
    if [ -z "${USER_PASSWORD}" ]
    then
	echo BLANK USER PASSWORD &&
	    exit 69
    fi &&
    echo &&
    read -s -p "VERIFY USER PASSWORD? " VERIFY_USER_PASSWORD &&
    if [ "${USER_PASSWORD}" == "${VERIFY_USER_PASSWORD}" ]
    then
	echo VERIFIED USER PASSWORD
    else
	echo FAILED TO VERIFY USER PASSWORD &&
	    exit 70
    fi &&
    echo &&
    echo &&
    echo VERIFIED &&
    if [ ! -d build ]
    then
	mkdir build
    fi &&
    mkdir ${TEMP_DIR}/root &&
    (cat > ${TEMP_DIR}/root/installer.env <<EOF
LUKS_PASSPHRASE=${LUKS_PASSPHRASE}
USER_PASSWORD=${USER_PASSWORD}
EOF
    ) &&
    mkdir ${TEMP_DIR}/root/secrets &&
    echo cd095fcf-1321-4da4-82e0-e8d22412f3d4 > ${TEMP_DIR}/root/secrets/verification.txt &&
    tar --create --file ${TEMP_DIR}/root.tar --directory ${TEMP_DIR}/root . &&
    rm --recursive --force ${TEMP_DIR}/root &&
    echo "${SYMMETRIC_PASSPHRASE}" | gpg --batch --passphrase-fd 0 --output build/root.tar.gpg --symmetric ${TEMP_DIR}/root.tar &&
    rm --force ${TEMP_DIR}/root.tar &&
    true
