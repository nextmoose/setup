#!/bin/sh

CID_FILE=$(mktemp) &&
	rm ${CID_FILE} &&
	sudo \
		docker \
		container \
		create \
		--cidfile ${CID_FILE} \
		--interactive \
		--tty \
		--rm \
		--env DISPLAY \
		--volume $(sudo docker volume ls --quiet --filter label=name=home | head -n 1):/home \
		--volume $(sudo docker volume ls --quiet --filter label=name=scripts | head -n 1):/opt/root/scripts:ro \
		--volume $(sudo docker volume ls --quiet --filter label=name=sudoers | head -n 1):/etc/sudoers.d:ro \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		--volume /var/run/docker.sock:/var/run/docker.sock:ro \
		--privileged \
		local/fedora \
		&&
	sudo \
		docker \
		network \
		connect \
		$(sudo docker network ls --filter label=name=main --quiet | head -n 1) \
		$(cat ${CID_FILE}) \
		&& 
	sudo docker container start --interactive $(cat ${CID_FILE}) &&
	sudo rm ${CID_FILE}
