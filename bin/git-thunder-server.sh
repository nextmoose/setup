#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	create)
	    shift &&
		git-thunder-server-create "${@}" &&
		shift ${#}
	    ;;
	major)
	    shift &&
		git-thunder-server-major "${@}" &&
		shift ${#}
	    ;;
	minor)
	    shift &&
		git-thunder-server-minor "${@}" &&
		shift ${#}
	*)
	    echo Unknown Option &&
		echo ${0} &&
		echo ${@} &&
		exit 64
	    ;;
    esac
done
