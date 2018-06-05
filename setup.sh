#!/bin/sh

cd $(mktemp -d) &&
    ./install-docker.sh &&
    ./install-docker-lvm-plugin.sh &&
    ./lvm-setup.sh &&
    ./start-docker.sh &&
    ./install-dnf-update-cron.sh &&
    sudo dnf install --assumeyes tmpwatch &&
    ./dnf-update.sh &&
    true