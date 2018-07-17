#!/bin/sh

/usr/bin/docker \
	container \
	run \
	--interactive \
	--tty \
	--volume /var/run/docker.sock:/var/run/docker.sock:ro \
	--volume 
	docker:18.05.0-ce \
	"${@}" \
	&&
	true
