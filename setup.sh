#!/bin/sh

./install-docker.sh &&
    ./install-docker-lvm-plugin.sh &&
    ./lvm-setup.sh &&
    ./start-docker.sh &&
    ./install-dnf-update-cron.sh &&
    ./start-xhost.sh &&
    ./configure.sh &&
    ./install-virtual-box.sh &&
    dnf update --assumeyes &&
    true