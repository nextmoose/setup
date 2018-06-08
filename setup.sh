#!/bin/sh

(
    cd native/${1}/${2} &&
        ./setup.sh
) &&
    sh docker/configure.sh