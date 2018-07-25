#!/bin/sh

docker \
	container \
	run \
	--interactive \
	--tty \
	--rm \
	--volume /var/run/docker.sock:/var/run/docker.sock \
	docker:18.06.0-ce \
	"${@}" \
	&&
	true
