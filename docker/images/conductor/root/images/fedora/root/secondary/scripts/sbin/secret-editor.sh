#!/bin/sh

docker \
	container \
	run \
	--interactive \
	--tty \
	--rm \
	--env GPG_SECRET_KEY \
	--env GPG_OWNER_TRUST \
	--env ORIGIN_HOST \
	--env ORIGIN_PORT \
	--env ORIGIN_USER \
	--env ORIGIN_ID_RSA \
	--env ORIGIN_ORGANIZATION \
	--env ORIGIN_REPOSITORY \
	--env COMMITTER_NAME \
	--env COMMITTER_EMAIL \
	local/secret-editor
