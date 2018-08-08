#!/bin/sh

dnf install --assumeyes dnf-plugins-core sudo &&
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo &&
    dnf install --assumeyes docker-common docker-latest &&
    true