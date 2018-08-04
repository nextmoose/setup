#!/bin/sh

sudo setenforce 0 &&
	sudo docker image build --tag local/conductor docker/image &&
	sudo \
		docker \
		container \
		run \
		--interactive \
		--tty \
		--rm \
		--volume /var/run/docker.sock:/var/run/docker.sock:ro \
		--env DISPLAY \
		--env GPG_SECRET_KEY="$(cat gpg.secret.key)" \
		--env GPG_OWNER_TRUST="$(cat gpg.owner.trust)" \
		--env GPG2_SECRET_KEY="$(cat gpg2.secret.key)" \
		--env GPG2_OWNER_TRUST="$(cat gpg2.owner.trust)" \
		--env SECRETS_HOST="github.com" \
		--env SECRETS_ORGANIZATION="nextmoose" \
		--env SECRETS_REPOSITORY="secrets" \
		local/conductor
