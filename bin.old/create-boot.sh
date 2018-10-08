#!/bin/sh

if [ ! -d /secrets/build ]
then
    sudo mkdir /secrets/build
fi &&
    if [ ! -f /secrets/build/luks.txt ]
    then
	uuidgen | sudo tee /secrets/build/luks.txt
    fi
