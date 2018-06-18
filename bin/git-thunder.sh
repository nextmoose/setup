#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	server)
	    shift &&
		git-thunder-server "${@}" &&
		exit 0
	    ;;
	client)
	    shift &&
		git-thunder-client "${@}" &&
		exit 0
	    ;;
	*)
	    echo Unknown Option &&
		echo ${0} &&
		echo ${#} &&
		exit 64
	    ;;
    esac
done
