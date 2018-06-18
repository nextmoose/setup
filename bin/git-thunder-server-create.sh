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
	--user-name)
	    USER_NAME="${2}" &&
	    	shift 2
	    ;;
	--user-email)
	    USER_EMAIL="${2}" &&
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
    elif [ -z "${USER_NAME}" ]
    then
	echo Unspecified USER_NAME &&
	    exit 67
    elif [ -z "${USER_EMAIL}" ]
    then
	echo Unspecified USER_EMAIL &&
	    exit 68
    fi &&
    mkdir -p "${HOME}/repositories/origin/${ORGANIZATION}/${PROJECT}"/0/0 &&
    git init --bare "${HOME}/origin/srv/${ORGANIZATION}/${PROJECT}/0/0" &&
    mkdir -p "${HOME}/repositories/upstream/${ORGANIZATION}/${PROJECT}"/0/0 &&
    git init --bare "${HOME}/upstream/srv/${ORGANIZATION}/${PROJECT}/0/0" &&
    WORK_DIR=$(mktemp -d) &&
    git init ${WORK_DIR} &&
    git -C ${WORK_DIR} remote add upstream "${HOME}/repositories/upstream/${ORGANIZATION/${PROJECT}/0/0" &&
    git -C ${WORK_DIR} config user.name "${USER_NAME}" &&
    git -C ${WORK_DIR} config user.email "${USER_EMAIL}" &&
    touch ${WORK_DIR}/.gitignore &&
    git -C ${WORK_DIR} add .gitignore &&
    git -C ${WORK_DIR} commit -m "initial commit" &&
    git -C ${WORK_DIR} push upstream master &&
    rm -rf ${WORK_DIR}
