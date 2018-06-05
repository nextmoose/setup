#!/bin/sh

sudo systemctl enable docker.service &&
    sudo systemctl start docker.service