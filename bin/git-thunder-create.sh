#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	--organization)
	    ORGANIZATION="${2}" &&
		shift 2
	    ;;
	--project)
	    PROJECT="${2}" &&
		shift 2
	    ;;
	*)
	    echo Unknown Option &&
		echo ${0} &&
		echo ${@} &&
		exit 64
	    ;;
    esac
done &&
    if [ -z "${ORGANIZATION}" ]
    then
	echo Unspecified ORGANIZATION &&
	    exit 65
    elif [ -z "${PROJECT}" ]
    then
	echo Unspecified PROJECT &&
	    exit 66
    fi &&
    mkdir -p "${HOME}/srv/${ORGANIZATION}/${PROJECT}"/0/0 &&
    git init --bare "${HOME}/srv/${ORGANIZATION}/${PROJECT}/0/0"
