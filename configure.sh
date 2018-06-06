#!/bin/sh

sudo docker network create browser &&
    DATA_DIR=$(mktemp -d) &&
    TEMP_DIR=$(mktemp -d) &&
    sudo \
        docker \
        container \
        create \
        --name browser \
        --restart always \
        --privileged \
        --mount type=bind,source=${DATA_DIR},destination=/data,readonly=false \
        --mount type=bind,source=/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
        --mount type=bind,source=/run/user/${UID}/pulse,destination=/run/user/${UID}/pulse,readonly=false \
        --mount type=bind,source=/etc/machine-id,destination=/etc/machine-id,readonly=false \
        --mount type=bind,source=/var/run/dbus/system_bus_socket,destination=/var/run/dbus/system_bus_socket,readonly=false \
        --mount type=bind,source=/var/lib/dbus,destination=/var/lib/dbus,readonly=false \
        --mount type=bind,source=${TEMP_DIR},destination=/tmp,readonly=false \
        --shm-size 256m \
        --label expiry=$(date --date "now + 1 month" +%s) \
        --env DISPLAY="${DISPLAY}" \
        --env TARGET_UID="${UID}" \
        --env XDG_RUNTIME_DIR=/run/user/${UID} \
        urgemerge/chromium-pulseaudio@sha256:21d8120ff7857afb0c18d4abf098549de169782e652437441c3c7778a755e46f \
        &&
    sudo docker network connect browser browser &&
    sudo docker container start browser &&
    true