#!/bin/sh

time sudo dnf update --assumeyes &&
	sudo dnf install --assumeyes docker &&
    ./install-docker-lvm-plugin.sh &&
    ./lvm-setup.sh &&
    ./start-docker.sh &&
    ./install-dnf-update-cron.sh &&
    sudo dnf install --assumeyes i3
