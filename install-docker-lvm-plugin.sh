#!/bin/sh

sudo dnf install --assumeyes golang git golang-github-cpuguy83-go-md2man &&
    cd $(mktemp -d) &&
    git clone https://github.com/projectatomic/docker-lvm-plugin.git &&
    cd docker-lvm-plugin &&
    echo A &&
    export GOPATH=$(mktemp -d) &&
    mkdir ${GOPATH}/src &&
    mkdir ${GOPATH}/src/github.com &&
    echo B &&
    go get ./... &&
    echo C &&
    make &&
    echo D &&
    sudo make install &&
    sudo sed -i "s#^VOLUME_GROUP=\$#VOLUME_GROUP=docker#" /etc/docker/docker-lvm-plugin