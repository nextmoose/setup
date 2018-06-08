#!/bin/sh

sudo umount /var/reserve/albums &&
    sudo umount /var/reserve/structure &&
    sudo rm -rf /var/reserve &&
    TEMP_FSTAB=$(mktemp $(pwd)/XXXXXXXX) &&
    sudo grep -v "/var/reserve" /etc/fstab > ${TEMP_FSTAB} &&
    cat ${TEMP_FSTAB} | sudo tee /etc/fstab &&
    sudo lvremove --force albums/var_reserve_albums &&
    sudo lvremove --force structure/var_reserve_structure &&
    sudo lvcreate --size 8G --name containers structure &&
    sudo lvcreate --size 8G --name overlay2 structure &&
    # mkfs.ext4 /dev/structure/containers &&
    # mkfs.ext4 /dev/structure/overlay2 &&
    # echo /dev/mapper/structure/containers /var/lib/docker/containers                   ext4    defaults        1 2 | tee --append /etc/fstab &&
    # echo /dev/mapper/structure/overlay2 /var/lib/docker/overlay2                   ext4    defaults        1 2 | tee --append /etc/fstab &&
    true