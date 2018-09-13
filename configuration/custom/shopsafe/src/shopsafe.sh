#!/bin/sh

IIDFILE=$(mktemp) &&
    CIDFILE=$(mktemp) &&
    cleanup() {
	sudo rm -f ${IIDFILE} ${CIDFILE}
    } &&
    cleanup &&
    trap cleanup EXIT &&
    CID=$(sudo docker container ls --quiet --filter label=uuid=${UUID}) &&
    if [ -z "${CID}" ]
    then
	sudo docker image build --iidfile ${IIDFILE} out/etc &&
	    sudo \
		docker \
		container \
		create \
		--cidfile ${CIDFILE} \
		--mount type=bind,source=/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
		--privileged \
		--env DISPLAY=:0 \
		--label uuid=${uuid} \
		$(cat ${IIDFILE}) &&
	    sudo docker container start $(cat ${CIDFILE}) &&
	    true
    else
	STATUS="$(sudo docker container inspect --format "{{ .State.Status }}" ${CID})" &&
	    if [ "${STATUS}" == "exited" ]
	    then
		sudo docker container restart ${CID}
	    else
		echo "CONTAINER ${CID} has unknown status ${STATUS}." &&
		    exit 65
	    fi &&
	    true
    fi &&
    true
