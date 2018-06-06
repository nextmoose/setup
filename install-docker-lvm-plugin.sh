#!/bin/sh

sudo dnf install --assumeyes golang git golang-github-cpuguy83-go-md2man &&
    export GOPATH=$(mktemp -d) &&
    mkdir ${GOPATH}/src &&
    mkdir ${GOPATH}/src/github.com &&
    cd $(mktemp -d) &&
    git clone https://github.com/projectatomic/docker-lvm-plugin.git &&
    cd docker-lvm-plugin &&
    echo A &&
    go get ./... &&
    go build &&
    echo B &&
    make &&
    echo C &&
    sudo make install &&
    sudo sed -i "s#^VOLUME_GROUP=\$#VOLUME_GROUP=docker#" /etc/docker/docker-lvm-plugin