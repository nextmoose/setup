#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	*)
	    echo Unknown Option &&
		echo ${1} &&
		echo ${0} &&
		echo ${@} &&
		exit 64
    esac
done &&
    if [ -f ${HOME}/.flag ]
    then
	sh /secrets/wifi.sh &&
	    TEMP=$(mktemp -d) &&
	    secrets gpg.secret.key > ${TEMP}/gpg.secrets.key &&
	    secrets gpg.owner.trust > ${TEMP}/gpg.owner.trust &&
	    secrets gpg2.secret.key > ${TEMP}/gpg2.secrets.key &&
	    secrets gpg2.owner.trust > ${TEMP}/gpg2.owner.trust &&
	    gpg --import ${TEMP}/gpg.secret.key &&
	    gpg --import-ownertrust ${TEMP}/gpg.owner.trust &&
	    gpg2 --import ${TEMP}/gpg2.secret.key &&
	    gpg2 --import-ownertrust ${TEMP}/gpg2.owner.trust &&
	    pass init $(gpg-key-id) &&
	    pass git init &&
	    pass git remote add origin https://github.com/nextmoose/secrets.git &&
	    pass git fetch origin master &&
	    pass git checkout origin/master &&
	    true
    fi &&
    xhost +local:
