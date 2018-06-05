#!/bin/sh

sudo dnf install --assumeyes golang git golang-github-cpuguy83-go-md2man &&
    cd $(mktemp -d) &&
    git clone https://github.com/projectatomic/docker-lvm-plugin.git &&
    cd docker-lvm-plugin &&
    go get ./...
    make &&
    sudo make install &&
    sed -i "s#^VOLUME_GROUP=\$#VOLUME_GROUP=docker#"