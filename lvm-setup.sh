#!/bin/sh

sudo umount /srv/lvm-plugin/reserve &&
    sudo rm -rf /srv/lvm-plugin/reserve &&
    TEMP_FSTAB=$(mktemp) &&
    sudo grep -v "/srv/lvm-plugin/reserve" /etc/fstab &&
    cat ${TEMP_FSTAB} | sudo tee /etc/fstab &&
    sudo lvremove docker/srv_lvm-plugin_reserve &&
    sudo lvcreate --size 10G --thin docker/thin &&
    true