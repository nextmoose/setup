#!/bin/sh

sudo umount /var/reserve/volumes &&
    sudo umount /var/reserve/system &&
    sudo rm -rf /var/reserve &&
    TEMP_FSTAB=$(mktemp $(pwd)/XXXXXXXX) &&
    sudo grep -v "/var/reserve" /etc/fstab > ${TEMP_FSTAB} &&
    cat ${TEMP_FSTAB} | sudo tee /etc/fstab &&
    sudo lvremove --force docker/var_reserve &&
    true