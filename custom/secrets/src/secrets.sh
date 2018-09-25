#!/bin/sh

if [ -f "OUT/etc/secrets/${@}" ]
then
    cat "OUT/etc/secrets/${@}"
else
    exit 65
