#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	repository)
	    shift &&
		git-thunder-repository "${@}" &&
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
