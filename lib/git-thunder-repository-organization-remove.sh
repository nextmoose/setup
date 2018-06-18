#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	--name)
	    NAME="${2}" &&
		shift 2
	    ;;
	--force)
	    FORCE="--force" &&
		shift
	    ;;
	*)
	    echo Unknown Option &&
		echo ${0} &&
		echo ${@} &&
		shift ${#} &&
		exit 64
    esac
done &&
    if [ -z "${NAME}" ]
    then
	echo Unspecified NAME &&
	    exit 65
    fi &&
    if [ ! -d "${HOME}/srv/repositories/${NAME}" ]
    then
	echo The ${NAME} organization does not exist. &&
	    exit 66
    fi &&
    rm --recursive "${FORCE}" "${HOME}/srv/repositories/${NAME}"
