#!/bin/sh

mkdir ${HOME}/keys &&
    seq 0 9 | while read I
    do
        uuidgen > ${HOME}/keys/key-${I}.bin
    done
