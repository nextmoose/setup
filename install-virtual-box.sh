#!/bin/sh

curl https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo | sudo tee /etc/yum.repos.d/virtualbox.repo &&
    dnf install --assumeyes VirtualBox &&
    true