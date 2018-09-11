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
	    gpg --import /secrets/gpg.secret.key &&
	    gpg --import-ownertrust /secrets/gpg.owner.trust &&
	    gpg2 --import /secrets/gpg2.secret.key &&
	    gpg2 --import-ownertrust /secrets/gpg2.owner.trust &&
	    pass init $(gpg-key-id) &&
	    pass git init &&
	    pass git remote add origin https://github.com/nextmoose/secrets.git &&
	    pass git fetch origin master &&
	    pass git checkout origin/master &&
	    true
    fi &&
    xhost +local:
