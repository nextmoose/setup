#!/bin/sh

sudo dnf install --assumeyes golang git golang-github-cpuguy83-go-md2man &&
    export GOPATH=$(mktemp -d) &&
    mkdir ${GOPATH}/src &&
    mkdir ${GOPATH}/src/github.com &&
    git -C ${GOPATH}/src clone https://github.com/projectatomic/docker-lvm-plugin.git &&
    echo B &&
    go build &&
    echo D &&
    make &&
    echo E &&
    sudo make install &&
    sudo sed -i "s#^VOLUME_GROUP=\$#VOLUME_GROUP=docker#" /etc/docker/docker-lvm-plugin