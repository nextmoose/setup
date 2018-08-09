#!/bin/sh

if [ ! -z "$(sudo docker container ls --quiet --all)" ]
then
	sudo docker container rm --force --volumes $(sudo docker container ls --quiet --all)
fi &&
	if [ ! -z "$(sudo docker volume ls --quiet)" ]
	then
		sudo docker volume rm $(sudo docker volume ls --quiet)
	fi &&
	if [ ! -z "$(sudo docker network ls --quiet)" ]
	then
		sudo docker network prune --force
	fi
