#!/bin/sh

if [ -f "/secrets/${2}" ]
then
    cat "/secrets/${2}"
else
    exit 65
fi
