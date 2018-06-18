#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	*)
	    echo Unsupported Option &&
		echo ${0} &&
		echo ${@} &&
		exit 64
    esac
done &&
    ls -1 ${HOME}/srv/repositories
