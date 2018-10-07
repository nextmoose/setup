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
    if [ ! -d build/real ]
    then
	mkdir build/real
    fi &&
    cp 
