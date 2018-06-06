#!/bin/sh

curl https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo | sudo tee /etc/yum.repos.d/virtualbox.repo &&
    sudo dnf update --assumeyes &&
    sudo dnf install --assumeyes VirtualBox &&
    true