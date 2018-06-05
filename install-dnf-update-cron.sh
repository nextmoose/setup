#!/bin/sh

sudo cp dnf-update.sh /etc/cron.hourly/dnf-update &&
    sudo chmod 0500 /etc/cron.hourly/dnf-update &&
    true