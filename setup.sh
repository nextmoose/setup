#!/bin/sh

cd $(mktemp -d) &&
    sudo dnf update --assumeyes &&
    sudo cp dnf-update.sh /etc/cron.hourly/dnf-update.sh &&
    true    