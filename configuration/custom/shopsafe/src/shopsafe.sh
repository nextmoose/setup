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
	--mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
	--privileged \
	--env DISPLAY=:0 \
	$(cat ${IIDFILE}) &&
    docker container start $(cat ${CIDFILE}) &&
    rm -f ${IIDFILE} ${CIDFILE}
