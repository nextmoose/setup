#!/bin/sh

if [ -f "/secrets/${@}" ]
then
    cat "/secrets/${@}"
else
    exit 65
fi
