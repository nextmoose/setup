#!/bin/sh

if [ ! -d build ]
then
    mkdir build
fi &&
    if [ ! -d build/configuration ]
    then
	mkdir build/configuration
    fi &&
    cp src/implementation/iso.nix build/configuration &&
    cp --recursive src/implementation/custom build/configuration &&
    true
