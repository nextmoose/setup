#!/bin/sh

sudo setenforce 0 &&
    sudo systemctl enable docker.service &&
    sudo systemctl enable docker-lvm-plugin &&
    sudo systemctl start docker.service &&
    sudo systemctl start docker-lvm-plugin
