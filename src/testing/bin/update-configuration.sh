#!/bin/sh

rsync \
    --verbose \
    --recursive \
    --whole-file \
    --delete \
    --progress \
    --itemize-changes \
    /mnt/configuration/. \
    /etc/nixos/
