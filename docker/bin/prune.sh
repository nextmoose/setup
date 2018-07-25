#!/bin/sh

sudo docker container ls --quiet --all | while read CONTAINER
do
	sudo docker container stop ${CONTAINER} &&
		sudo docker container rm --volumes ${CONTAINER}
done &&
	sudo docker volume ls --quiet | while read VOLUME
	do
		sudo docker volume rm ${VOLUME}
	done &&
	# sudo rm -f /run/keys/. &&
	sudo docker network ls --quiet --filter label=timestamp | while read NETWORK
	do
		sudo docker network rm ${NETWORK}
	done
