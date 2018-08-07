#!/bin/sh

TIMESTAMP=$(date +%s) &&
	key_file(){
		KEY_FILE=$(mktemp /run/docker/encrypted/key-XXXXXXXX) &&
			uuidgen > ${KEY_FILE} &&
			echo ${KEY_FILE}
	} &&
	WORKSPACE_VOLUME=$(docker volume create --driver lvm --opt thinpool --opt size=1G) &&
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
		--interactive \
		--tty \
		--volume /var/run/docker.sock:/var/run/docker.sock:ro \
		--volume ${WORKSPACE_VOLUME}:/opt/cloud9/workspace \
		--volume /run/docker/encrypted:/run/docker/encrypted \
		--volume /run/docker/unencrypted:/run/docker/unencrypted \
		--env PROJECT_NAME=inner \
		--env CLOUD9_PORT=18326 \
		--env GPG_SECRET_KEY \
		--env GPG_OWNER_TRUST \
		--env GPG2_SECRET_KEY \
		--env GPG2_OWNER_TRUST \
		--env SECRETS_HOST \
		--env SECRETS_ORGANIZATION \
		--env SECRETS_REPOSITORY \
		--label timestamp=${TIMESTAMP} \
		rebelplutonium/inner:1.0.13 \
		&&
	MAIN=$(docker network create $(uuidgen) --label timestamp=${TIMESTAMP}) &&
	docker network connect ${MAIN} $(cat browser.cid) &&
	docker network connect --alias inner ${MAIN} $(cat inner.cid) &&
	docker network disconnect bridge $(cat inner.cid) &&
	docker container start $(cat browser.cid) $(cat inner.cid) &&
	true
