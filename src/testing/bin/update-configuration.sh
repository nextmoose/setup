#!/bin/sh

sudo \
    rsync \
    --verbose \
    --recursive \
    --whole-file \
    --delete \
    --progress \
    --itemize-changes \
    /mnt/configuration/. \
    /etc/nixos/ &&
    sudo nixos-rebuild switch &&
    true
