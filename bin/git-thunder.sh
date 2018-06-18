#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	server)
	    shift &&
		git-thunder-server "${@}" &&
		shift ${#}
	    ;;
	client)
	    shift &&
		git-thunder-client "${@}" &&
		shift ${#}
	    ;;
	*)
	    echo Unknown Option &&
		echo ${0} &&
		echo ${#} &&
		exit 64
	    ;;
    esac
done
