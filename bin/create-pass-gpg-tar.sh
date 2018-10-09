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
    read -s -p "VERIFY SYMMETRIC PASSPHRASE? " VERIFY_SYMMETRIC_PASSPHRASE &&
    if [ "${SYMMETRIC_PASSPHRASE}" == "${VERIFY_SYMMETRIC_PASSPHRASE}" ]
    then
	echo VERIFIED SYMMETRIC PASSPHRASE
    else
	echo FAILED TO VERIFY SYMMETRIC PASSPHRASE &&
	    exit 67
    fi &&
    read -s -p "LUKS PASSPHRASE? " LUKS_PASSPHRASE &&
    if [ -z "${LUKS_PASSPHRASE}" ]
    then
	echo BLANK LUKS PASSPHRASE &&
	    exit 67
    fi &&
    read -s -p "VERIFY LUKS PASSPHRASE? " VERIFY_LUKS_PASSPHRASE &&
    if [ "${LUKS_PASSPHRASE}" == "${VERIFY_LUKS_PASSPHRASE}" ]
    then
	echo VERIFIED LUKS PASSPHRASE
    else
	echo FAILED TO VERIFY LUKS PASSPHRASE &&
	    exit 68
    fi &&
    if [ ! -d build ]
    then
	mkdir build
    fi &&
    mkdir ${TEMP_DIR}/pass &&
    echo "${LUKS_PASSPHRASE}" > ${TEMP_DIR}/pass/luks.txt &&
    tar --create --file ${TEMP_DIR}/pass.tar --directory ${TEMP_DIR}/pass . &&
    rm --recursive --force ${TEMP_DIR}/pass &&
    echo "${SYMMETRIC_PASSPHRASE}" | gpg --batch --passphrase-fd 0 --output build/pass.tar.gz --symmetric ${TEMP_DIR}/pass.tar &&
    rm --force ${TEMP_DIR}/pass.tar &&
    true
