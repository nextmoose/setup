#!/bin/sh

sudo umount /var/reserve &&
    sudo rm -rf /var/reserve &&
    TEMP_FSTAB=$(mktemp) &&
    sudo grep -v "/var/reserve" /etc/fstab &&
    cat ${TEMP_FSTAB} > /etc/fstab &&
    true