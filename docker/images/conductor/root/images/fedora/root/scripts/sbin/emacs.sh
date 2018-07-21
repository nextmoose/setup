#!/bin/sh

CID_FILE=$(mktemp) &&
	rm ${CID_FILE} &&
	cleanup(){
		docker container stop $(cat ${CID_FILE}) &&
			docker container rm $(cat ${CID_FILE}) &&
			rm -f ${CID_FILE}
	} &&
	# trap cleanup EXIT &&
	docker \
		container \
		create \
		--cidfile ${CID_FILE} \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		--env DISPLAY \
		--env UPSTREAM_URL \
		--env ORIGIN_URL \
		--env REPORT_URL \
		--env COMMITTER_NAME \
		--env COMMITTER_EMAIL \
		--env MASTER_BRANCH \
		--env UPSTREAM_HOST \
		--env UPSTREAM_ID_RSA \
		--env ORIGIN_HOST \
		--env ORIGIN_ID_RSA \
		--env REPORT_HOST \
		--env REPORT_ID_RSA \
		--volume $(docker volume create --driver lvm --opt thinpool --opt size=1G):/usr/local/src \
		local/emacs \
		&&
	docker \
		container \
		start \
		$(cat ${CID_FILE}) \
		&&
	true
