#!/bin/sh

mkdir build/installation-verification &&
    cp --recursive src/testing/installation build/installation-verification &&
    cd build/installation-verification &&
    nix-build test.nix
