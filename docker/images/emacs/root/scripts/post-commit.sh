#!/bin/sh

[ ! -z "${ORIGIN_URL}" ] &&
	while ! git push origin $(git rev-parse HEAD)
	do
		sleep 10s
	done
