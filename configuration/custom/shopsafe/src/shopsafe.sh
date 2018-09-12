#!/bin/sh

IIDFILE=$(mktemp) &&
    rm -f ${IIDFILE} &&
    docker image build --iidfile ${IIDFILE} . &&
    CIDFILE=$(mktemp) &&
    rm -f ${CIDFILE} &&
    docker \
	container \
	create \
	--cidfile ${CIDFILE} \
	--mount type=bind,source=/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
	--privileged \
	--env DISPLAY=:0 \
	$(cat ${IIDFILE}) &&
    docker container start $(cat ${CIDFILE}) &&
    rm -f ${IIDFILE} ${CIDFILE}
