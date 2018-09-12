#!/bin/sh

IIDFILE=$(mktemp) &&
    rm -f ${IIDFILE} &&
    sudo docker image build --iidfile ${IIDFILE} out &&
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
	--privileged \
	--env DISPLAY=:0 \
	$(cat ${IIDFILE}) &&
    docker container start --interactive $(cat ${CIDFILE}) &&
    rm -f ${IIDFILE} ${CIDFILE}
