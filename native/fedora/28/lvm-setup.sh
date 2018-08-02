#!/bin/sh

sudo umount /var/reserve/albums &&
    sudo rm -rf /var/reserve &&
    TEMP_FSTAB=$(mktemp $(pwd)/XXXXXXXX) &&
    sudo grep -v "/var/reserve" /etc/fstab > ${TEMP_FSTAB} &&
    cat ${TEMP_FSTAB} | sudo tee /etc/fstab &&
    sudo lvremove --force albums/var_reserve_albums
