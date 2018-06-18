#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	--name)
	    NAME=${2} &&
		shift 2
	;;
	*)
	    echo Unknown Option &&
		echo ${0} &&
		echo ${@} &&
		exit 64
    esac
done &&
    if [ -z "${NAME}" ]
    then
	echo Unspecified NAME &&
	    exit 65
    fi &&
    mkdir -p ${HOME}/srv/repositories &&
    if [ -d "${HOME}/srv/repositories/${NAME}" ]
    then
	echo The ${NAME} organization already exists. &&
	    exit 66
    fi &&
    mkdir "${HOME}/srv/repositories/${NAME}"
