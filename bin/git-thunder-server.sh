#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	create)
	    shift &&
		git-thunder-create "${@}" &&
		shift ${#}
	    ;;
	*)
	    echo Unknown Option &&
		echo ${0} &&
		echo ${@} &&
		exit 64
	    ;;
    esac
done
