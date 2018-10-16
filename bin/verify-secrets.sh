#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${TEMP_DIR}
    } &&
    trap cleanup EXIT &&
    read -s -p "SYMMETRIC PASSPHRASE? " SYMMETRIC_PASSPHRASE &&
    echo &&
    read -s -p "LUKS PASSPHRASE? " VERIFY_LUKS_PASSPHRASE &&
    echo &&
    read -s -p "USER PASSWORD? " VERIFY_USER_PASSWORD &&
    echo &&
    echo "${SYMMETRIC_PASSPHRASE}" | gpg --batch --passphrase-fd 0 --output ${TEMP_DIR}/root.tar --decrypt build/root.tar.gpg &&
    mkdir ${TEMP_DIR}/root &&
    tar --extract --file ${TEMP_DIR}/root.tar --directory ${TEMP_DIR}/root &&
    rm --force ${TEMP_DIR}/root.tar &&
    source ${TEMP_DIR}/root/installer.env &&
    if [ "${LUKS_PASSPHRASE}" == "${VERIFY_LUKS_PASSPHRASE}" ]
    then
	echo VERIFIED LUKS PASSPHRASE
    else
	echo FAILED TO VERIFY LUKS PASSPHRASE &&
	    exit 65
    fi &&
    if [ "${USER_PASSWORD}" == "${VERIFY_USER_PASSWORD}" ]
    then
	echo VERIFIED USER PASSWORD
    else
	echo FAILED TO VERIFY USER PASSWORD &&
	    exit 66
    fi &&
    if [ "$(cat ${TEMP_DIR}/root/secrets/verification.txt)" == "cd095fcf-1321-4da4-82e0-e8d22412f3d4" ]
    then
	echo VERIFIED VERIFICATION SECRET
    else
	echo FAILED TO VERIFY VERIFICATION SECRET &&
	    exit 67
    fi &&
    rm --recursive --force ${TEMP_DIR}/root &&
    true
