#!/bin/sh

sudo chmod 0600 /etc/cron.hourly/dnf-update.sh &&
    sudo dnf install --assumeyes golang git golang-github-cpugyu83-go-md2man &&
    git clone git@github.com:shishir-a412ed/docker-lvm-plugin.git &&
    cd docker-lvm-plugin &&
    make &&
    make install 