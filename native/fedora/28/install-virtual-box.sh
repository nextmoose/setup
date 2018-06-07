#!/bin/sh

curl https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo | sudo tee /etc/yum.repos.d/virtualbox.repo &&
    sudo dnf install --assumeyes gcc kernel-devel kernel-headers dkms make bzip2 perl kernel-devel-$(uname -r)  &&
    sudo dnf install --assumeyes VirtualBox-5.2 &&
    sudo /sbin/vboxconfig &&
    true