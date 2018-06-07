#!/bin/sh

./install-docker.sh &&
    sudo ./install-docker-lvm-plugin.sh &&
    ./lvm-setup.sh &&
    ./start-docker.sh &&
    ./install-dnf-update-cron.sh &&
    ./start-xhost.sh &&
    ./install-virtual-box.sh &&
    sudo dnf update --assumeyes &&
    true