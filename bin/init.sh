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
done
PRIVATE_VOLUME=24fd963r &&
    if [ ! -z $(sudo lvs --options lv_name volumes | grep "^\s*${PRIVATE_VOLUME}\s*\$") ]
    then
	DIR=$(mktemp -d /tmp/XXXXXXXX) &&
	    sudo mount /dev/volumes/${PRIVATE_VOLUME} ${DIR} &&
	    sh ${DIR}/wifi.sh &&
	    gpg --import ${DIR}/gpg.secret.key &&
	    gpg --import-ownertrust ${DIR}/gpg.owner.trust &&
	    gpg2 --import ${DIR}/gpg2.secret.key &&
	    gpg2 --import-ownertrust ${DIR}/gpg2.owner.trust &&
	    pass init $(gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":") &&
	    pass git init &&
	    pass git remote add origin https://github.com/nextmoose/secrets.git &&
	    pass git fetch origin master &&
	    pass git checkout origin/master &&
	    sudo umount ${DIR} &&
	    rm -rf ${DIR} &&
	    sudo lvremove --force /dev/volumes/${PRIVATE_VOLUME} &&
	    true
    fi &&
    ls -1 ${HOME}/completion | while read FILE
    do
	source ${HOME}/completion/${FILE}
    done
