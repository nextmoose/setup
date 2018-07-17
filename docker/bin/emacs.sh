#!/bin/sh

HOMEY=$(sudo docker volume create --driver lvm --opt thinpool --opt size 10G) &&
	sudo \
		docker \
		container \
		create \
		--mount type=volume,source=${HOMEY},destination=/home \
		local/emacs:28
