#!/bin/sh

if [ "${1}" == "show" ]
then
    cat OUT/etc/${2}
fi
