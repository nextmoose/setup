#!/bin/sh

TIMESTAMP=$(date +%s) &&
	key_file(){
		KEY_FILE=$(mktemp /run/docker/encrypted/key-XXXXXXXX) &&
			uuidgen > ${KEY_FILE} &&
			echo ${KEY_FILE}
	} &&
	docker \
		container \
		create \
		--cidfile browser.cid \
		--mount type=bind,source=/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
		--env DISPLAY \
		--privileged \
		--label timestamp=${TIMESTAMP} \
		urgemerge/chromium-pulseaudio@sha256:21d8120ff7857afb0c18d4abf098549de169782e652437441c3c7778a755e46f \
		&&
	docker \
		container \
		create \
		--cidfile inner.cid \
		--privileged \
		--label timestamp=${TIMESTAMP} \
		--env CLOUD9_WORKSPACE=/opt/cloud9/workspace \
		--env CLOUD9_PORT=18326 \
		rebelplutonium/cloud9:1.4.12 \
		&&
	MAIN=$(docker network create $(uuidgen) --label timestamp=${TIMESTAMP}) &&
	docker network connect ${MAIN} $(cat browser.cid) &&
	docker network connect --alias inner ${MAIN} $(cat inner.cid) &&
	docker network disconnect bridge $(cat inner.cid) &&
	docker container start $(cat browser.cid) $(cat inner.cid) &&
	true
