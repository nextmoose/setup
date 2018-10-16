#!/bin/sh

if [ "${1}" == "show" ]
then
    cat OUT/etc/secrets/${2}
fi
