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
	--major)
	    MAJOR="${2}" &&
		shift 2
	    ;;
	--minor)
	    MINOR="${2}" &&
		shift 2
	    ;;
	--name)
	    NAME="${2}" &&
	    	shift 2
	    ;;
	--message)
	    MESSAGE="${2}
	*)
	    echo Unsupported Option &&
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
	    exit 65
    elif [ -z "${MAJOR}" ]
    then
	echo Unspecified MAJOR &&
	    exit 66
    elif [ -z "${MINOR}" ]
    then
	echo Unspecified MINOR &&
	    exit 67
    fi &&
    if [ ! -d ${HOME}/repositories/origin/${ORGANIZATION}/${PROJECT}/${MAJOR}/${MINOR} ]
       echo The origin repository does not exist. &&
	   exit 68
       elif [ ! -d ${HOME}/repositories/upstream/${ORGANIZATION}/${PROJECT}/${MAJOR}/${MINOR} ]
       echo The upstream repository does not exist. &&
	   exit 69
       fi
    mkdir -p ${HOME}/working &&
    cd $(mktemp -d ${HOME}/working/XXXXXXXX) &&
    git init &&
    git remote add origin ${HOME}/repositories/origin/${ORGANIZATION}/${PROJECT}/${MAJOR}/${MINOR} &&
    git remote add upstream ${HOME}/repositories/upstream/${ORGANIZATION}/${PROJECT}/${MAJOR}/${MINOR} &&
    git remote set-url --push upstream no_push
    git branch 
