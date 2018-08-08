#!/bin/sh

KEYFILE=$(mktemp /run/docker/encrypted/XXXXXXXX) &&
    uuidgen > ${KEYFILE} &&
    docker volume --driver lvm --opt thinpool --opt size=1G --opt key=${KEYFILE}