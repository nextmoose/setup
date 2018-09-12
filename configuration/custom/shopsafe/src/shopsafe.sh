#!/bin/sh

IIDFILE=$(mktemp) &&
    CIDFILE=$(mktemp) &&
    cleanup() {
	sudo rm -f ${IIDFILE} ${CIDFILE}
    } &&
    rm -f ${CIDFILE} ${IIDFILE} &&
    sudo docker image build --iidfile ${IIDFILE} out/etc &&
    CIDFILE=$(mktemp) &&
    rm -f ${CIDFILE} &&
    sudo \
	docker \
	container \
	create \
	--cidfile ${CIDFILE} \
	--interactive \
	--tty \
	--rm \
	--mount type=bind,source=/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
	--mount type=bind,source=/home/user,destination=/home/user \
	--privileged \
	--env DISPLAY=:0 \
	$(cat ${IIDFILE}) &&
    sudo docker container start --interactive $(cat ${CIDFILE}) &&
    true
