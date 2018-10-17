#!/bin/sh

sudo \
    rsync \
    --verbose \
    --whole-file \
    --delete \
    --progress \
    --itemize-changes \
    /mnt/configuration/configuration.nix. \
    /etc/nixos/configuration.nix &&
    sudo \
	rsync \
	--verbose \
	--recursive \
	--whole-file \
	--delete \
	--progress \
	--itemize-changes \
	/mnt/configuration/custom/. \
	/etc/nixos/custom/ &&
    sudo nixos-rebuild switch &&
    true
