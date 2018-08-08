#!/bin/sh

sudo docker image build --tag local/old-docker docker/old-docker &&
    sudo \
        docker \
        container \
        run \
        --interactive \
        --tty \
        --rm \
        --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
        --mount type=bind,source=/run/docker/encrypted,destination=/run/docker/encrypted \
        local/old-docker