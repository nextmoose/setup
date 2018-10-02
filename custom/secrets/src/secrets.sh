#!/bin/sh

if [ ${1} == "show" ]
then
    if [ -f "/var/run/secrets/${2}" ]
    then
	cat "/var/run/secrets/${2}"
    else
	exit 65
    fi
else
    exit 66
fi
