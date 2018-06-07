#!/bin/sh

sudo ./alpha.sh &&
    ./seed-private-keys.sh &&
    ./start-xhost.sh &&
    true