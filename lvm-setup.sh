#!/bin/sh

sudo umount /srv/lvm-plugin/reserve &&
    sudo rm -rf /srv/lvm-plugin/reserve &&
    TEMP_FSTAB=$(mktemp) &&
    sudo grep -v "/srv/lvm-plugin/reserve" /etc/fstab &&
    cat ${TEMP_FSTAB} > /etc/fstab &&
    lvcreate --size 10G --thin docker/thin &&
    true