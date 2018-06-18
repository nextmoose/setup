#!/bin/sh

git_thunder() {
    while [ ${#} -gt 0 ]
    do
	case ${1} in
	    repository)
		shift &&
		    thunder_repository "${@}" &&
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
} &&
    git_thunder_repository() {
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		error)
		    exit 99
		    ;;
		*)
		    echo Unknown Option &&
			echo ${0} &&
			echo ${@} &&
			exit 64
		    ;;
	    esac
	done
    } &&
    git_thunder "${@}"
