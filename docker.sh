#!/bin/sh

sudo docker image build --tag local/conductor docker/images/conductor &&
	sudo docker \
		container \
		run \
		--interactive \
		--tty \
		--rm \
		--volume $(pwd)/gpg.secret.key:/gpg.secret.key:ro \
		--volume $(pwd)/gpg.owner.trust:/gpg.owner.trust:ro \
		--volume /var/run/docker.sock:/var/run/docker.sock:ro \
		--volume /run/keys:/run/keys \
		--volume /home/user/bin/:/srv/bin \
		local/conductor
