#!/bin/sh

export PATH=${PATH}:GIT &&
    while ! git push origin $(git rev-parse --abbrev-ref HEAD --)
    do
	sleep 1s
    done
