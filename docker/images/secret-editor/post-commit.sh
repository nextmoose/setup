#!/bin/sh

while ! git push origin $(git rev-parse HEAD --abbrev-ref HEAD | grep -v ^HEAD$ || git rev-parse HEAD)
do
	sleep 10s
done
