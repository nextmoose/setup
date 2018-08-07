#!/bin/sh

TIMESTAMP=$(date +%s) &&
	key_file(){
		KEY_FILE=$(mktemp /run/docker/encrypted/key-XXXXXXXX) &&
			uuidgen > ${KEY_FILE} &&
			echo ${KEY_FILE}
	} &&
	WORKSPACE_VOLUME=$(docker volume create --driver lvm --opt thinpool --opt size=1G) &&
	GITLAB_CONFIG_VOLUME=$(docker volume create --driver lvm --opt thinpool --opt size=1G) &&
	GITLAB_LOGS_VOLUME=$(docker volume create --driver lvm --opt thinpool --opt size=1G) &&
	GITLAB_DATA_VOLUME=$(docker volume create --driver lvm --opt thinpool --opt size=1G) &&
	export MAIN_NETWORK=$(docker network create $(uuidgen) --label timestamp=${TIMESTAMP}) &&
	docker \
		container \
		create \
		--cidfile browser.cid \
		--mount type=bind,source=/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
		--env DISPLAY \
		--privileged \
		--shm-size 256m \
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
		--env MAIN_NETWORK \
		--label timestamp=${TIMESTAMP} \
		rebelplutonium/inner:1.0.13 \
		&&
	docker \
		container \
		create \
		--cidfile gitlab.cid \
		--volume ${GITLAB_CONFIG_VOLUME}:/etc/gitlab \
		--volume ${GITLAB_LOGS_VOLUME}:/var/log/gitlab \
		--volume ${GITLAB_DATA_VOLUME}:/var/opt/gitlab \
		gitlab/gitlab-ce:11.1.4-ce.0 \
		&&
	docker network connect ${MAIN_NETWORK} $(cat browser.cid) &&
	docker network connect --alias inner ${MAIN_NETWORK} $(cat inner.cid) &&
	docker network connect --alias gitlab ${MAIN_NETWORK} $(cat gitlab.cid) &&
	docker network disconnect bridge $(cat inner.cid) &&
	docker network disconnect bridge $(cat gitlab.cid) &&
	docker container start $(cat browser.cid) $(cat inner.cid) $(cat gitlab.cid) &&
	true
