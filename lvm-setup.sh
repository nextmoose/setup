#!/bin/sh

sudo umount /var/reserve/reserve &&
    sudo rm -rf /var/reserve/reserve &&
    TEMP_FSTAB=$(mktemp) &&
    sudo grep -v "/var/reserve/reserve" /etc/fstab &&
    cat ${TEMP_FSTAB} | sudo tee /etc/fstab &&
    sudo lvremove --force docker/var_reserve &&
    true