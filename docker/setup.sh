#!/bin/sh

sudo docker image pull fedora:28 &&
	KEYS=$(sudo docker volume create --driver lvm --opt size=1G --opt key=/home/user/keys/keys-0.bin) &&
	HOMEY=$(sudo docker volume create --driver lvm --opt size=8G --opt key=/home/user/keys/key-1.bin) &&
	echo A1 &&
	sudo \
		docker \
		container \
		run \
		--interactive \
		--tty \
		--rm \
		--mount type=volume,source=${KEYS},destination=/output \
		--mount type=bind,source=$(pwd),destination=/input,readonly=true \
		fedora:28 \
		cp /input/gpg.secret.key /output \
	&&
	echo A1 &&
	sudo \
		docker \
		container \
		create \
		--interactive \
		--tty \
		--name entrypoint \
		--mount type=volume,source=${HOMEY},destination=/home \
		--mount type=volume,source=${KEYS},destination=/srv/keys,readonly=true \
		--mount type=bind,source=/,destination=/srv/host,readonly=true \
		--restart always \
		fedora:28 \
		bash \
	&&
	sudo docker network create local &&
	sudo docker network connect local entrypoint &&
	sudo docker container start entrypoint
