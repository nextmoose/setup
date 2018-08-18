#!/bin/sh

PRIVATE_VOLUME=24fd963r &&
    if [ ! -z $(sudo lvs --options lv_name volumes | grep "^\s*${PRIVATE_VOLUME}\s*\$") ]
    then
	DIR=$(mktemp -d /tmp/XXXXXXXX) &&
	    sudo mount /dev/volumes/${PRIVATE_VOLUME} ${DIR} &&
	    sh ${DIR}/wifi.sh &&
	    sudo umount ${DIR} &&
	    rm -rf ${DIR} &&
	    lvremove --force /dev/volumes/${PRIVATE_VOLUME}
    fi
