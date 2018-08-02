#!/bin/sh

CIDFILE=$(mktemp) &&
	rm -f ${CIDFILE} &&
	sudo setenforce 0 &&
        WORKSPACE_VOLUME=$(sudo docker volume create --driver lvm --opt thinpool --opt size=1G) &&
	cleanup(){
		sudo docker container inspect $(cat ${CIDFILE}) &&
			sudo docker container logs $(cat ${CIDFILE}) &&
			sudo docker container rm --force --volumes $(cat ${CIDFILE}) &&
			sudo rm -f ${CIDFILE} &&
			sudo docker volume rm ${WORKSPACE_VOLUME}
	} &&
	trap cleanup EXIT &&
	sudo \
		docker \
		container \
		create \
		--cidfile ${CIDFILE} \
		--interactive \
		--tty \
		--volume /var/run/docker.sock:/var/run/docker.sock:ro \
		--volume ${WORKSPACE_VOLUME}:/opt/cloud9/workspace \
		--env PROJECT_NAME=xxx \
		--env CLOUD9_PORT=18326 \
		--env GPG_SECRET_KEY="$(cat gpg.secret.key)" \
		--env GPG_OWNER_TRUST="$(cat gpg.owner.trust)" \
		--env GPG2_SECRET_KEY="$(cat gpg2.secret.key)" \
		--env GPG2_OWNER_TRUST="$(cat gpg2.owner.trust)" \
		--env GPG_KEY_ID=D65D3F8C \
		--env USER_NAME="Emory Merryman" \
		--env USER_EMAIL="emory.merryman@gmail.com" \
		--env SECRETS_HOST=github.com \
		--env SECRETS_ORGANIZATION=nextmoose \
		--env SECRETS_REPOSITORY=secrets \
		rebelplutonium/inner:1.0.8 \
		&&
	sudo docker network disconnect bridge $(cat ${CIDFILE}) &&
	sudo docker network connect --alias xxx 1ad4f542-7b1f-4b8c-8410-95655a42d5b0 $(cat ${CIDFILE}) &&
	sudo docker container start --interactive $(cat ${CIDFILE})
