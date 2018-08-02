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
		local/conductor
