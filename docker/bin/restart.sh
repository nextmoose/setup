#!/bin/sh

sudo setenforce 0 &&
	sh docker/bin/prune.sh &&
	sh ./docker.sh &&
	shell &&
	sh docker/bin/prune.sh
