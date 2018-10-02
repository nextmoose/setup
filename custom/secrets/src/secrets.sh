#!/bin/sh

if [ -f "/var/run/secrets/${2}" ]
then
    cat "/var/run/secrets/${2}"
else
    exit 65
fi
