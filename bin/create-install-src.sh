#!/bin/sh

if [ ! -d build ]
then
    mkdir build
fi &&
    if [ ! -d build/src ]
    then
	mkdir build/src
    fi &&
    cp src/iso.nix build/src &&
    true
